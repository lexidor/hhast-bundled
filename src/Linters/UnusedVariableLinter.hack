/*
 *  Copyright (c) 2017-present, Facebook, Inc.
 *  All rights reserved.
 *
 *  This source code is licensed under the MIT license found in the
 *  LICENSE file in the root directory of this source tree.
 *
 */

namespace Facebook\HHAST;

use namespace HH\Lib\{C, Keyset, Str, Vec};

final class UnusedVariableLinter extends AutoFixingASTLinter {
  const type TConfig = shape();
  const type TNode = VariableExpression;
  const type TContext = IFunctionishDeclaration;
  /**
   * The autofix may change the behavior of existing code.
   * It changes the name of `$a` in this example to `$_a`.
   * This makes the return statement return `3`, instead of `4`.
   * ```
   * $_a = 4;
   * list($a) = tuple(3);
   * return $_a;
   * ```
   * Each autofix should be individually checked.
   */
  use UnsafeBulkAutoFixesTrait;

  <<__Override>>
  public function getLintErrorForNode(
    IFunctionishDeclaration $functionish,
    VariableExpression $node,
  ): ?ASTLintError {

    $parent = $functionish->getParentOfDescendant($node);
    if ($parent is MemberSelectionExpression) {
      // $this->x() : $this is used
      // $this->x = $foo: all vars are used
      // $x = $this->y: $this and $this->y are used, $x is checked separately
      return null;
    }

    $var = $node->getExpression();
    if (!$var is VariableToken) {
      return null;
    }
    $name = $var->getText();

    // $_ is the convention for marking a variable unused
    // Use of $GLOBALS by definition may happen outside the scope of $functionish
    if (Str\starts_with($name, '$_') || $name === '$GLOBALS') {
      return null;
    }

    // If this variable is inside a lambda function, we should be looking in the
    // lambda's header and body, not the enclosing function/method.
    $lambda = $functionish->getClosestAncestorOfDescendantOfType<
      LambdaExpression,
    >($node);

    $vars = $lambda is nonnull
      ? $this->classifyLambdaVariables($lambda)
      : $this->classifyFunctionishVariables($functionish);

    if (C\contains($vars['used'], $name)) {
      return null;
    }

    // If a variable is not classified as used then we are currently
    // evaluating an unused assignment.
    return new ASTLintError(
      $this,
      'Variable is unused',
      $node,
      () ==> $this->getFixedNode($node, $functionish),
    );
  }

  /**
   * Get parameters that are passed by reference or marked inout which are always
   * considered "used".
   *
   * This also looks for parameters to anonymous functions and lambda expressions
   * that are passed by reference or marked inout and treats those as always
   * used. This is done to avoid false positives at the cost of potential false
   * negatives (unused variables that are not identified as unused).
   */
  private function getAlwaysUsedVariables(
    vec<ParameterDeclaration> $params,
    Node $body,
  ): keyset<string> {
    $anon_fns = $body->getDescendantsByType<AnonymousFunction>();
    $lambdas = $body->getDescendantsByType<LambdaExpression>();

    $anon_fn_params = Vec\map($anon_fns, $fn ==> {
      $params = $fn->getParameters();
      return $params is null
        ? vec[]
        : $params->getDescendantsByType<ParameterDeclaration>();
    })
      |> Vec\flatten($$);

    $lambda_params = Vec\map($lambdas, $lambda ==> {
      $signature = $lambda->getSignature();
      return $signature is LambdaSignature
        ? $signature->getDescendantsByType<ParameterDeclaration>()
        : vec[];
    })
      |> Vec\flatten($$);

    return Vec\filter(
      Vec\concat($params, $anon_fn_params, $lambda_params),
      $p ==> self::isByRefParam($p) || self::isInoutParam($p),
    )
      |> Keyset\map($$, $p ==> self::getParamName($p));
  }

  private static function isInoutParam(ParameterDeclaration $param): bool {
    return $param->getCallConvention() is InoutToken;
  }

  private static function isByRefParam(ParameterDeclaration $param): bool {
    $name = $param->getName();
    return
      $name is DecoratedExpression && $name->getDecorator() is AmpersandToken;
  }

  private static function getParamName(ParameterDeclaration $param): string {
    $name = $param->getName();
    return $name is VariableToken
      ? $name->getText()
      : (
          ($name as DecoratedExpression)->getExpression() as VariableToken
        )->getText();
  }

  private function getFunctionishParts(
    IFunctionishDeclaration $functionish,
  ): (vec<ParameterDeclaration>, CompoundStatement) {
    if ($functionish is FunctionDeclaration) {
      $body = $functionish->getBody();
      $header = $functionish->getDeclarationHeader();
    } else if ($functionish is MethodishDeclaration) {
      $body = $functionish->getFunctionBody();
      $header = $functionish->getFunctionDeclHeader();
    } else {
      invariant_violation("Couldn't find functionish for variable expression");
    }

    if ($body === null) {
      invariant_violation(
        'Abstract methods cannot contain variable expressions',
      );
    }

    $params = vec[];
    if ($header->getParameterList() is nonnull) {
      foreach ($header->getParameterListx()->getChildrenOfItems() as $param) {
        if ($param is ParameterDeclaration) {
          $params[] = $param;
        }
      }
    }

    return tuple($params, $body as CompoundStatement);
  }

  private function getLambdaParts(
    LambdaExpression $lambda,
  ): (vec<ParameterDeclaration>, Node) {
    $sig = $lambda->getSignature();
    if ($sig is LambdaSignature) {
      $params = vec[];
      if ($sig->getParameters() is nonnull) {
        foreach ($sig->getParametersx()->getChildrenOfItems() as $param) {
          if ($param is ParameterDeclaration) {
            $params[] = $param;
          }
        }
      }
    } else {
      $params = vec[
        new ParameterDeclaration(
          null,
          null,
          null,
          null,
          null,
          new VariableExpression($sig as VariableToken),
          null,
        ),
      ];
    }
    return tuple($params, $lambda->getBody());
  }

  /**
   * Classify every variable expression in `$body` as an assignment or a use.
   *
   * An assignment is a variable expression that is one of the following:
   *
   * 1a. The left-hand side of a binary expression with an assignment operator
   *   that is not part of the index of a subscript expression.
   * 2. The key or value of a foreach clause
   * 3. The members of a list expression
   *
   * Any non-assignment of a variable is considered to be a use. This means that
   * bugs or oversights in this method will cause false negatives.
   *
   * Examples of assignment:
   * ```
   * // 1.
   * $a = 1;
   * $b .= 'foo';
   * $by_id[2] = 'baz';
   *
   * // 2.
   * foreach ($items as $k => $v) {}
   *
   * // 3.
   * list($a, $b) = $parts;
   * ```
   */
  <<__Memoize>>
  private function classifyLambdaVariables(
    LambdaExpression $lambda,
  ): shape('assigned' => keyset<string>, 'used' => keyset<string>) {
    return $this->classifyVariables(...$this->getLambdaParts($lambda));
  }

  <<__Memoize>>
  private function classifyFunctionishVariables(
    IFunctionishDeclaration $fun,
  ): shape('assigned' => keyset<string>, 'used' => keyset<string>) {
    return $this->classifyVariables(...$this->getFunctionishParts($fun));
  }

  private function classifyVariables(
    vec<ParameterDeclaration> $params,
    Node $body,
  ): shape('assigned' => keyset<string>, 'used' => keyset<string>) {
    $ret = shape('assigned' => vec[], 'used' => vec[]);
    foreach ($body->getDescendantsByType<VariableExpression>() as $var) {
      if (
        $this->isVariableAssignment($var, $body->getAncestorsOfDescendant($var))
      ) {
        $ret['assigned'][] = $var;
      } else {
        $ret['used'][] = $var;
      }
    }

    $ret['assigned'] = Keyset\map(
      $ret['assigned'],
      $v ==> ($v->getExpression() as VariableToken)->getText(),
    );
    $ret['used'] = Keyset\map(
      $ret['used'],
      $v ==> ($v->getExpression() as VariableToken)->getText(),
    );

    foreach ($this->getAlwaysUsedVariables($params, $body) as $name) {
      $ret['used'][] = $name;
    }

    return $ret;
  }

  /**
   * Return whether `$var` is being assigned in the scope of `$parents`.
   */
  private function isVariableAssignment(
    VariableExpression $var,
    vec<Node> $parents,
  ): bool {
    foreach (Vec\reverse($parents) as $parent) {
      if ($parent === $var) {
        continue;
      }

      // Too early to tell
      if ($parent is ListItem<_> || $parent is NodeList<_>) {
        continue;
      }

      // SubscriptExpression
      // $a[$b]
      // ^^ ^^
      // |  +-- index
      // +-- receiver
      //
      // A variable in the index of a subscript expression is never an assignment
      // A variable that is the receiver of a subscript expression may be an assignment or use; continue until a BinaryExpression is found.
      //
      // $a[$b] = '123'; // assignment of $a, use of $b
      // f($a[$b]);      // use of $a
      if ($parent is SubscriptExpression) {
        $index = $parent->getIndex();
        if ($index !== null && $index->isAncestorOf($var)) {
          return false;
        } else {
          continue;
        }
      }

      if (
        $parent is BinaryExpression &&
        $this->isAssignmentExpression($parent) &&
        $parent->getLeftOperand()->isAncestorOf($var)
      ) {
        return true;
      }

      if (
        $parent is ForeachStatement &&
        (($parent->getValue() === $var) || ($parent->getKey() === $var))
      ) {
        return true;
      }

      if (
        $parent is ListExpression &&
        (bool)$parent->getMembers()?->isAncestorOf($var)
      ) {
        return true;
      }

      break;
    }

    return false;
  }

  /**
   * These are all the return types of BinaryExpression::getOperator
   * that contain "Equal" and are not comparison operators.
   */
  private function isAssignmentExpression(BinaryExpression $expr): bool {
    $op = $expr->getOperator();
    return (
      $op is AmpersandEqualToken ||
      $op is BarEqualToken ||
      $op is CaratEqualToken ||
      $op is DotEqualToken ||
      $op is EqualToken ||
      $op is GreaterThanGreaterThanEqualToken ||
      $op is LessThanLessThanEqualToken ||
      $op is MinusEqualToken ||
      $op is PercentEqualToken ||
      $op is PlusEqualToken ||
      $op is QuestionQuestionEqualToken ||
      $op is SlashEqualToken ||
      $op is StarEqualToken ||
      $op is StarStarEqualToken
    );
  }

  /**
   * Return a fixed node if possible.
   *
   * Most unused assignments require user evaluation to fix. An unused assignment
   * that has a typo should be corrected; others should be deleted. List
   * expressions and foreach keys/values are exceptions where it is safe to
   * suggest renaming the variable.
   */
  public function getFixedNode(
    VariableExpression $node,
    IFunctionishDeclaration $functionish,
  ): VariableExpression {
    $expr = $node->getExpression();
    if (!$expr is VariableToken) {
      return $node;
    }

    $parents = $functionish->getAncestorsOfDescendant($node);
    $should_autofix = (
      C\any($parents, $p ==> $p is ListExpression) ||
      C\any(
        $parents,
        $p ==> $p is ForeachStatement &&
          (($p->getValue() === $node) || ($p->getKey() === $node)),
      )
    );

    if ($should_autofix) {
      return $node->withExpression(
        $expr->withText('$_'.Str\strip_prefix($expr->getText(), '$')),
      );
    } else {
      return $node;
    }
  }

  <<__Override>>
  public function getTitleForFix(ASTLintError $err): string {
    $expr = ($err->getBlameNode() as this::TNode);
    $token = $expr->getExpression();
    invariant($token is VariableToken, 'unhandled type');

    $new_name = '$_'.Str\strip_prefix($token->getText(), '$');
    return Str\format('Rename to `%s`', $new_name);
  }
}
