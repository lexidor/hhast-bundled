/*
 *  Copyright (c) 2017-present, Facebook, Inc.
 *  All rights reserved.
 *
 *  This source code is licensed under the MIT license found in the
 *  LICENSE file in the root directory of this source tree.
 *
 */

namespace Facebook\HHAST;

final class UnusedPipeVariableLinterTest extends TestCase {
  use LinterTestTrait;

  <<__Override>>
  protected function getLinter(string $file): UnusedPipeVariableLinter {
    return UnusedPipeVariableLinter::fromPath($file);
  }

  <<__Override>>
  public function getCleanExamples(): vec<(string)> {
    return vec[
      tuple(
        '<?hh function foo(): string { return "abc" |> Str\uppercase($$); }',
      ),
    ];
  }
}
