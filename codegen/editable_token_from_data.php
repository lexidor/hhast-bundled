<?hh // strict
/**
 * This file is generated. Do not modify it manually!
 *
 * @generated SignedSource<<7e4227d1e1476866f4673dcdab2ddc77>>
 */
namespace Facebook\HHAST\__Private;
use namespace Facebook\HHAST;

function editable_token_from_data(
  string $file,
  int $offset,
  string $token_kind,
  HHAST\EditableNode $leading,
  HHAST\EditableNode $trailing,
  string $token_text,
): HHAST\EditableToken {
  $cls = TokenClassMap::WITHOUT_TEXT[$token_kind] ?? null;
  if ($cls !== null) {
    return new $cls($leading, $trailing);
  }
  $cls = TokenClassMap::WITH_TEXT[$token_kind] ?? null;
  if ($cls !== null) {
    return new $cls($leading, $trailing, $token_text);
  }
  throw new HHAST\UnsupportedTokenError($file, $offset, $token_kind);
}

class TokenClassMap {

  const dict<
    string,
    classname<HHAST\EditableTokenWithVariableText>,
  > WITH_TEXT = dict[
    'abstract' => HHAST\AbstractToken::class,
    'and' => HHAST\AndToken::class,
    'array' => HHAST\ArrayToken::class,
    'arraykey' => HHAST\ArraykeyToken::class,
    'as' => HHAST\AsToken::class,
    'async' => HHAST\AsyncToken::class,
    'attribute' => HHAST\AttributeToken::class,
    'await' => HHAST\AwaitToken::class,
    'binary' => HHAST\BinaryToken::class,
    'bool' => HHAST\BoolToken::class,
    'boolean' => HHAST\BooleanToken::class,
    'break' => HHAST\BreakToken::class,
    'case' => HHAST\CaseToken::class,
    'catch' => HHAST\CatchToken::class,
    'category' => HHAST\CategoryToken::class,
    'children' => HHAST\ChildrenToken::class,
    'class' => HHAST\ClassToken::class,
    'classname' => HHAST\ClassnameToken::class,
    'clone' => HHAST\CloneToken::class,
    'concurrent' => HHAST\ConcurrentToken::class,
    'const' => HHAST\ConstToken::class,
    '__construct' => HHAST\ConstructToken::class,
    'continue' => HHAST\ContinueToken::class,
    'coroutine' => HHAST\CoroutineToken::class,
    'darray' => HHAST\DarrayToken::class,
    'declare' => HHAST\DeclareToken::class,
    'default' => HHAST\DefaultToken::class,
    'define' => HHAST\DefineToken::class,
    '__destruct' => HHAST\DestructToken::class,
    'dict' => HHAST\DictToken::class,
    'do' => HHAST\DoToken::class,
    'double' => HHAST\DoubleToken::class,
    'echo' => HHAST\EchoToken::class,
    'else' => HHAST\ElseToken::class,
    'elseif' => HHAST\ElseifToken::class,
    'empty' => HHAST\EmptyToken::class,
    'enddeclare' => HHAST\EnddeclareToken::class,
    'endfor' => HHAST\EndforToken::class,
    'endforeach' => HHAST\EndforeachToken::class,
    'endif' => HHAST\EndifToken::class,
    'endswitch' => HHAST\EndswitchToken::class,
    'endwhile' => HHAST\EndwhileToken::class,
    'enum' => HHAST\EnumToken::class,
    'eval' => HHAST\EvalToken::class,
    'extends' => HHAST\ExtendsToken::class,
    'fallthrough' => HHAST\FallthroughToken::class,
    'file' => HHAST\FileToken::class,
    'final' => HHAST\FinalToken::class,
    'finally' => HHAST\FinallyToken::class,
    'float' => HHAST\FloatToken::class,
    'for' => HHAST\ForToken::class,
    'foreach' => HHAST\ForeachToken::class,
    'from' => HHAST\FromToken::class,
    'function' => HHAST\FunctionToken::class,
    'global' => HHAST\GlobalToken::class,
    'goto' => HHAST\GotoToken::class,
    '__halt_compiler' => HHAST\HaltCompilerToken::class,
    'if' => HHAST\IfToken::class,
    'implements' => HHAST\ImplementsToken::class,
    'include' => HHAST\IncludeToken::class,
    'include_once' => HHAST\Include_onceToken::class,
    'inout' => HHAST\InoutToken::class,
    'instanceof' => HHAST\InstanceofToken::class,
    'insteadof' => HHAST\InsteadofToken::class,
    'int' => HHAST\IntToken::class,
    'integer' => HHAST\IntegerToken::class,
    'interface' => HHAST\InterfaceToken::class,
    'is' => HHAST\IsToken::class,
    'isset' => HHAST\IssetToken::class,
    'keyset' => HHAST\KeysetToken::class,
    'let' => HHAST\LetToken::class,
    'list' => HHAST\ListToken::class,
    'mixed' => HHAST\MixedToken::class,
    'namespace' => HHAST\NamespaceToken::class,
    'new' => HHAST\NewToken::class,
    'newtype' => HHAST\NewtypeToken::class,
    'noreturn' => HHAST\NoreturnToken::class,
    'null' => HHAST\NullLiteralToken::class,
    'num' => HHAST\NumToken::class,
    'object' => HHAST\ObjectToken::class,
    'or' => HHAST\OrToken::class,
    'parent' => HHAST\ParentToken::class,
    'print' => HHAST\PrintToken::class,
    'private' => HHAST\PrivateToken::class,
    'protected' => HHAST\ProtectedToken::class,
    'public' => HHAST\PublicToken::class,
    '?as' => HHAST\QuestionAsToken::class,
    'real' => HHAST\RealToken::class,
    'reify' => HHAST\ReifyToken::class,
    'require' => HHAST\RequireToken::class,
    'require_once' => HHAST\Require_onceToken::class,
    'required' => HHAST\RequiredToken::class,
    'resource' => HHAST\ResourceToken::class,
    'return' => HHAST\ReturnToken::class,
    'self' => HHAST\SelfToken::class,
    'shape' => HHAST\ShapeToken::class,
    'static' => HHAST\StaticToken::class,
    'string' => HHAST\StringToken::class,
    'super' => HHAST\SuperToken::class,
    'suspend' => HHAST\SuspendToken::class,
    'switch' => HHAST\SwitchToken::class,
    'this' => HHAST\ThisToken::class,
    'throw' => HHAST\ThrowToken::class,
    'trait' => HHAST\TraitToken::class,
    'try' => HHAST\TryToken::class,
    'tuple' => HHAST\TupleToken::class,
    'type' => HHAST\TypeToken::class,
    'unset' => HHAST\UnsetToken::class,
    'use' => HHAST\UseToken::class,
    'using' => HHAST\UsingToken::class,
    'var' => HHAST\VarToken::class,
    'varray' => HHAST\VarrayToken::class,
    'vec' => HHAST\VecToken::class,
    'void' => HHAST\VoidToken::class,
    'where' => HHAST\WhereToken::class,
    'while' => HHAST\WhileToken::class,
    'xor' => HHAST\XorToken::class,
    'yield' => HHAST\YieldToken::class,
    'binary_literal' => HHAST\BinaryLiteralToken::class,
    'boolean_literal' => HHAST\BooleanLiteralToken::class,
    'decimal_literal' => HHAST\DecimalLiteralToken::class,
    'double_quoted_string_literal' =>
      HHAST\DoubleQuotedStringLiteralToken::class,
    'double_quoted_string_literal_head' =>
      HHAST\DoubleQuotedStringLiteralHeadToken::class,
    'double_quoted_string_literal_tail' =>
      HHAST\DoubleQuotedStringLiteralTailToken::class,
    'error_token' => HHAST\ErrorTokenToken::class,
    'execution_string_literal' => HHAST\ExecutionStringLiteralToken::class,
    'execution_string_literal_head' =>
      HHAST\ExecutionStringLiteralHeadToken::class,
    'execution_string_literal_tail' =>
      HHAST\ExecutionStringLiteralTailToken::class,
    'floating_literal' => HHAST\FloatingLiteralToken::class,
    'heredoc_string_literal' => HHAST\HeredocStringLiteralToken::class,
    'heredoc_string_literal_head' => HHAST\HeredocStringLiteralHeadToken::class,
    'heredoc_string_literal_tail' => HHAST\HeredocStringLiteralTailToken::class,
    'hexadecimal_literal' => HHAST\HexadecimalLiteralToken::class,
    'markup' => HHAST\MarkupToken::class,
    'name' => HHAST\NameToken::class,
    'nowdoc_string_literal' => HHAST\NowdocStringLiteralToken::class,
    'octal_literal' => HHAST\OctalLiteralToken::class,
    'PU_atom' => HHAST\PUAtomToken::class,
    'single_quoted_string_literal' =>
      HHAST\SingleQuotedStringLiteralToken::class,
    'string_literal_body' => HHAST\StringLiteralBodyToken::class,
    'variable' => HHAST\VariableToken::class,
    'XHP_body' => HHAST\XHPBodyToken::class,
    'XHP_category_name' => HHAST\XHPCategoryNameToken::class,
    'XHP_class_name' => HHAST\XHPClassNameToken::class,
    'XHP_comment' => HHAST\XHPCommentToken::class,
    'XHP_element_name' => HHAST\XHPElementNameToken::class,
    'XHP_string_literal' => HHAST\XHPStringLiteralToken::class,
  ];
  const dict<string, classname<HHAST\EditableTokenWithFixedText>> WITHOUT_TEXT =
    dict[
      'end_of_file' => HHAST\EndOfFileToken::class,
      '&' => HHAST\AmpersandToken::class,
      '&&' => HHAST\AmpersandAmpersandToken::class,
      '&=' => HHAST\AmpersandEqualToken::class,
      '@' => HHAST\AtToken::class,
      '\\' => HHAST\BackslashToken::class,
      '|' => HHAST\BarToken::class,
      '||' => HHAST\BarBarToken::class,
      '|=' => HHAST\BarEqualToken::class,
      '|>' => HHAST\BarGreaterThanToken::class,
      '^' => HHAST\CaratToken::class,
      '^=' => HHAST\CaratEqualToken::class,
      ':' => HHAST\ColonToken::class,
      '::' => HHAST\ColonColonToken::class,
      ',' => HHAST\CommaToken::class,
      '$' => HHAST\DollarToken::class,
      '$$' => HHAST\DollarDollarToken::class,
      '.' => HHAST\DotToken::class,
      '...' => HHAST\DotDotDotToken::class,
      '.=' => HHAST\DotEqualToken::class,
      '=' => HHAST\EqualToken::class,
      '==' => HHAST\EqualEqualToken::class,
      '===' => HHAST\EqualEqualEqualToken::class,
      '==>' => HHAST\EqualEqualGreaterThanToken::class,
      '=>' => HHAST\EqualGreaterThanToken::class,
      '!' => HHAST\ExclamationToken::class,
      '!=' => HHAST\ExclamationEqualToken::class,
      '!==' => HHAST\ExclamationEqualEqualToken::class,
      '>' => HHAST\GreaterThanToken::class,
      '>=' => HHAST\GreaterThanEqualToken::class,
      '>>' => HHAST\GreaterThanGreaterThanToken::class,
      '>>=' => HHAST\GreaterThanGreaterThanEqualToken::class,
      '{' => HHAST\LeftBraceToken::class,
      '[' => HHAST\LeftBracketToken::class,
      '(' => HHAST\LeftParenToken::class,
      '<' => HHAST\LessThanToken::class,
      '<=' => HHAST\LessThanEqualToken::class,
      '<=>' => HHAST\LessThanEqualGreaterThanToken::class,
      '<>' => HHAST\LessThanGreaterThanToken::class,
      '<<' => HHAST\LessThanLessThanToken::class,
      '<<=' => HHAST\LessThanLessThanEqualToken::class,
      '<?' => HHAST\LessThanQuestionToken::class,
      '</' => HHAST\LessThanSlashToken::class,
      '-' => HHAST\MinusToken::class,
      '-=' => HHAST\MinusEqualToken::class,
      '->' => HHAST\MinusGreaterThanToken::class,
      '--' => HHAST\MinusMinusToken::class,
      '%' => HHAST\PercentToken::class,
      '%=' => HHAST\PercentEqualToken::class,
      '+' => HHAST\PlusToken::class,
      '+=' => HHAST\PlusEqualToken::class,
      '++' => HHAST\PlusPlusToken::class,
      '?' => HHAST\QuestionToken::class,
      '?:' => HHAST\QuestionColonToken::class,
      '?>' => HHAST\QuestionGreaterThanToken::class,
      '?->' => HHAST\QuestionMinusGreaterThanToken::class,
      '??' => HHAST\QuestionQuestionToken::class,
      '??=' => HHAST\QuestionQuestionEqualToken::class,
      '}' => HHAST\RightBraceToken::class,
      ']' => HHAST\RightBracketToken::class,
      ')' => HHAST\RightParenToken::class,
      ';' => HHAST\SemicolonToken::class,
      '/' => HHAST\SlashToken::class,
      '/=' => HHAST\SlashEqualToken::class,
      '/>' => HHAST\SlashGreaterThanToken::class,
      '*' => HHAST\StarToken::class,
      '*=' => HHAST\StarEqualToken::class,
      '**' => HHAST\StarStarToken::class,
      '**=' => HHAST\StarStarEqualToken::class,
      '~' => HHAST\TildeToken::class,
    ];
}
