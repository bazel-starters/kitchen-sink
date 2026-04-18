# Polyglot Bazel Starter

    # This is executable Markdown that's tested on CI.
    # How is that possible? See https://gist.github.com/bwoods/1c25cb7723a06a076c2152a2781d4d49
    set -o errexit -o nounset -o xtrace
    alias ~~~=":<<'~~~sh'";:<<'~~~sh'

This repo includes:
- 🧱 Latest version of Bazel and dependencies
- 📦 Curated bazelrc flags via [bazelrc-preset.bzl]
- 🧰 Developer environment setup with [bazel_env.bzl]
- 🎨 Formatting and Linting using rules_lint
- ✅ Pre-commit hooks for automatic linting and formatting

> [!NOTE]
> You can customize languages and features with the interactive wizard in the <code>aspect init</code> command.
> <code>init</code> is an alternative to this starter repo, which was generated using the 'kitchen-sink' preset.
> See https://docs.aspect.build/cli/overview

## Setup dev environment

First, we recommend you setup a Bazel-based developer environment with direnv.

1. install https://direnv.net/docs/installation.html
1. run <code>direnv allow</code> and follow the prompts to <code>bazel run //tools:bazel_env</code>

This isn't strictly required, but the commands which follow assume that needed tools are on the PATH,
so skipping `direnv` means you're responsible for installing them yourself.

## Try it out

Many commands are available on the PATH thanks to direnv:

~~~sh
copier --help
yq --help
~~~
