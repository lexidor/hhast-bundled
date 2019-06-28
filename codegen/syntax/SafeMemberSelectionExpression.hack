/**
 * This file is generated. Do not modify it manually!
 *
 * @generated SignedSource<<eee25dd94dd5f53331cae0dac76ecf1f>>
 */
namespace Facebook\HHAST;
use namespace Facebook\TypeAssert;

<<__ConsistentConstruct>>
final class SafeMemberSelectionExpression
  extends Node
  implements ILambdaBody, IExpression {

  const string SYNTAX_KIND = 'safe_member_selection_expression';

  private Node $_object;
  private Node $_operator;
  private Node $_name;

  public function __construct(
    Node $object,
    Node $operator,
    Node $name,
    ?__Private\SourceRef $source_ref = null,
  ) {
    $this->_object = $object;
    $this->_operator = $operator;
    $this->_name = $name;
    parent::__construct($source_ref);
  }

  <<__Override>>
  public static function fromJSON(
    dict<string, mixed> $json,
    string $file,
    int $initial_offset,
    string $source,
    string $_type_hint,
  ): this {
    $offset = $initial_offset;
    $object = Node::fromJSON(
      /* HH_FIXME[4110] */ $json['safe_member_object'],
      $file,
      $offset,
      $source,
      'IExpression',
    );
    $offset += $object->getWidth();
    $operator = Node::fromJSON(
      /* HH_FIXME[4110] */ $json['safe_member_operator'],
      $file,
      $offset,
      $source,
      'QuestionMinusGreaterThanToken',
    );
    $offset += $operator->getWidth();
    $name = Node::fromJSON(
      /* HH_FIXME[4110] */ $json['safe_member_name'],
      $file,
      $offset,
      $source,
      'NameToken',
    );
    $offset += $name->getWidth();
    $source_ref = shape(
      'file' => $file,
      'source' => $source,
      'offset' => $initial_offset,
      'width' => $offset - $initial_offset,
    );
    return new static($object, $operator, $name, $source_ref);
  }

  <<__Override>>
  public function getChildren(): dict<string, Node> {
    return dict[
      'object' => $this->_object,
      'operator' => $this->_operator,
      'name' => $this->_name,
    ];
  }

  <<__Override>>
  public function rewriteChildren(
    self::TRewriter $rewriter,
    vec<Node> $parents = vec[],
  ): this {
    $parents[] = $this;
    $object = $rewriter($this->_object, $parents);
    $operator = $rewriter($this->_operator, $parents);
    $name = $rewriter($this->_name, $parents);
    if (
      $object === $this->_object &&
      $operator === $this->_operator &&
      $name === $this->_name
    ) {
      return $this;
    }
    return new static($object, $operator, $name);
  }

  public function getObjectUNTYPED(): Node {
    return $this->_object;
  }

  public function withObject(IExpression $value): this {
    if ($value === $this->_object) {
      return $this;
    }
    return new static($value ?? Missing(), $this->_operator, $this->_name);
  }

  public function hasObject(): bool {
    return !$this->_object->isMissing();
  }

  /**
   * @return FunctionCallExpression | MemberSelectionExpression |
   * SafeMemberSelectionExpression | ScopeResolutionExpression |
   * VariableExpression
   */
  public function getObject(): IExpression {
    return TypeAssert\instance_of(IExpression::class, $this->_object);
  }

  /**
   * @return FunctionCallExpression | MemberSelectionExpression |
   * SafeMemberSelectionExpression | ScopeResolutionExpression |
   * VariableExpression
   */
  public function getObjectx(): IExpression {
    return $this->getObject();
  }

  public function getOperatorUNTYPED(): Node {
    return $this->_operator;
  }

  public function withOperator(QuestionMinusGreaterThanToken $value): this {
    if ($value === $this->_operator) {
      return $this;
    }
    return new static($this->_object, $value ?? Missing(), $this->_name);
  }

  public function hasOperator(): bool {
    return !$this->_operator->isMissing();
  }

  /**
   * @return QuestionMinusGreaterThanToken
   */
  public function getOperator(): QuestionMinusGreaterThanToken {
    return TypeAssert\instance_of(
      QuestionMinusGreaterThanToken::class,
      $this->_operator,
    );
  }

  /**
   * @return QuestionMinusGreaterThanToken
   */
  public function getOperatorx(): QuestionMinusGreaterThanToken {
    return $this->getOperator();
  }

  public function getNameUNTYPED(): Node {
    return $this->_name;
  }

  public function withName(NameToken $value): this {
    if ($value === $this->_name) {
      return $this;
    }
    return new static($this->_object, $this->_operator, $value ?? Missing());
  }

  public function hasName(): bool {
    return !$this->_name->isMissing();
  }

  /**
   * @return NameToken
   */
  public function getName(): NameToken {
    return TypeAssert\instance_of(NameToken::class, $this->_name);
  }

  /**
   * @return NameToken
   */
  public function getNamex(): NameToken {
    return $this->getName();
  }
}
