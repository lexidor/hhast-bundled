/*
 *  Copyright (c) 2017-present, Facebook, Inc.
 *  All rights reserved.
 *
 *  This source code is licensed under the MIT license found in the
 *  LICENSE file in the root directory of this source tree.
 *
 */

namespace Facebook\HHAST;

final class NoByRefCallArgumentsLinterTest extends TestCase {
  use AutoFixingLinterTestTrait<ASTLintError>;

  protected function getLinter(string $file): NoByRefCallArgumentsLinter {
    return NoByRefCallArgumentsLinter::fromPath($file);
  }

  public function getCleanExamples(): vec<(string)> {
    return vec[
      tuple('<?hh foo($bar);'),
      tuple('<?hh function foo(int &$bar): void {}'),
      tuple('<?hh $foo = &$bar;'),
    ];
  }
}