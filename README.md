# HHAST

## How to run this on hhvm 6.23 inside a docker container.

 - `cd /app`
 - `export HHVM_DISABLE_PERSONALITY=1`
 - `git clone https://github.com/lexidor/hhast-bundled`
 - `cd hhast-bundled`
 - `hhvm -m server -p 8080 -dhhvm.server.request_timeout_seconds=30`
   - You may also need to add `-vServer.AllowRunAsRoot=1` if you are root in the container.
 - `watch http://localhost:8080/bin/hhast.hack`

What is does.
 - This will lint hhast itself in a loop.
 - You will first see some timeouts: "entire web request took longer than 30 seconds"
 - After approximately 180 seconds, you'll see "Deleting JIT ProfData".
   - You should now see "No errors." in the curl output.
   - If you don't see this message, increase the timeout like so `-dhhvm.server.request_timeout_seconds=90` and try again.
 - You are now running a very heavily jitted codebase.

## Trust

Trusting some random code from someone on the internet is always risky.
Here are some steps you can to prove to yourself I am not trying to hack ur box.

 - Verify that `5b898deb41922ae8763fed0f3616295c01545181` is indeed in hhvm/hhast.
 - Nuke `vendor/` and run a composer install.
   - This will restore `vendor/` without any patches or trickery.
   - You will need to install composer in your container, see [explanation](./explanation.txt) and [getcomposer.org](https://getcomposer.org).
 - Verify the patch `dc62c6cbc3b79f48e4f0d50aadb20c4424c87fd2`.
   - The rationale behind the changes can be found in [explanation](./explanation.txt).
 - Verify that the next commit (the one I am authoring right now) only touches this README.
   - I can't include the commit hash before I commit, so check `git log` for the latest commit.

## Back to the original README

[![Continuous Integration](https://github.com/hhvm/hhast/actions/workflows/build-and-test.yml/badge.svg)](https://github.com/hhvm/hhast/actions/workflows/build-and-test.yml)

HHAST is a toolkit for processing the AST of Hack files.

Abstract syntax trees can be an extremely powerful basis for many kinds of tooling beyond compilers and optimization; HHAST is built on top of Hack's Full Fidelity Parser (FFP), providing a Hack object representation of a *mutable* AST.

Unlike traditional ASTs, the FFP's AST includes all 'trivia' - such as whitespace and comments - allowing you to fully recreate the file from the AST, or create an updated file after mutating the AST, preserving comments and whitespace.

HHAST has 3 main APIs:

* a low-level library for inspecting and manipulating the FFP AST
* a linting framework, with support for auto-fixing linters
* a migration framework

## Linters

 - [user documentation](docs/linters-usage.md)
 - [developer documentation](docs/linters-development.md)

![screenshot of lint errors](docs/linters.png)

Linters are designed for subjective or style changes which do not substantially alter the behavior of the code, and may be rejected on a case-by-case basis. Lint errors can provide a suggested fix, which may be based on an AST mutation, but doesn't have to be.

We've included several linters as a starting point, including:

* don't use await in a loop
* methods should be ->lowerCamelCase(), functions should be under_scored()
* always use braces for control flow
* always use [`<<__Override>>`](https://docs.hhvm.com/hack/attributes/special#__override) where possible

Linters can be used both interactively, or unattended. Autofixing is not supported unattended, however it will exit with non-zero if there are any lint issues, to ease integration with CI systems.

### Editor and IDE Support

![screenshot of lint errors in VSCode](docs/linters-vscode.png)

HHAST is supported by:

- [ALE] for Vim 8 and neovim
- [atom-ide-hhast] for Atom IDE and Nuclide
- [vscode-hack] for Visual Studio Code

## Migrations

- [user documentation](docs/migrations-usage.md)
- most of the [linters developer documentation](docs/linters-development.md)
  applies for migrations too

![screenshot of a migration](docs/migrations.png)

Migrations are for sweeping changes you want to apply across your entire codebase, and are often more complex. Taking this into account, the migration framework has built-in support for multi-step migrations (unlike linters). AST-aware migrations can be a powerful tool for:

* adjusting for changes to the language (for example, the shape changes described below)
* replacing deprecated APIs with new ones
* general clean-up of the codebase

## Low-level AST library

See [the documentation](docs/ast-lib.md).

## License

HHAST is MIT-licensed.

[atom-ide-hhast]: https://github.com/hhvm/atom-ide-hhast/
[ALE]: https://github.com/w0rp/ale/
[vscode-hack]: https://marketplace.visualstudio.com/items?itemName=pranayagarwal.vscode-hack
