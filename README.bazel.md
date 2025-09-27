# Bazel workflows

This repository uses [Aspect Workflows](https://aspect.build) to provide an excellent Bazel developer experience.

## Formatting code

The `format` command is provided by the `.envrc` file, and the bazel-env.bzl setup in this repo.

- Run `format` to re-format all files locally.
- Run `format path/to/file` to re-format a single file.
- Run `pre-commit install` to auto-format changed files on `git commit`.
- For CI verification, setup `format` task, see https://docs.aspect.build/workflows/features/lint#formatting## Linting code

Projects use [rules_lint](https://github.com/aspect-build/rules_lint) to run linting tools using Bazel's aspects feature.
Linters produce report files, which they cache like any other Bazel actions.
You can print the report files to the terminal in a couple ways, as follows.

The Aspect CLI provides the [`lint` command](https://docs.aspect.build/cli/commands/aspect_lint) but it is *not* part of the Bazel CLI provided by Google.
The command collects the correct report files, presents them with colored boundaries, gives you interactive suggestions to apply fixes, produces a matching exit code, and more.

- Run `aspect lint //...` to check for lint violations.

## Installing dev tools

For developers to be able to run additional CLI tools without needing manual installation:

1. Add the tool to `tools/tools.lock.json`
2. Run `bazel run //tools:bazel_env` (following any instructions it prints)
3. When working within the workspace, tools will be available on the PATH

See https://blog.aspect.build/run-tools-installed-by-bazel for details.

## Working with npm packages

To install a `node_modules` tree locally for the editor or other tooling outside of Bazel:

```shell
% pnpm install
```

Similarly, you can run other `pnpm` commands to add or remove packages. Use `bazel info workspace` to avoid having a bunch of `../` segments when running tools from a subdirectory:

```shell
path/to/package% $(bazel info workspace)/tools/pnpm add http-server
```

This ensures you use the same pnpm version as other developers, and the lockfile format stays constant.## Working with Python packages

After adding a new `import` statement in Python code, run `bazel run gazelle` to update the BUILD file.

If the package is not already a dependency of the project, you have to do some additional steps:

```shell
# Update dependencies table to include your new dependency
% vim pyproject.toml
# Update lock files to pin this dependency
% ./tools/repin
```

To create a runnable binary for a console script from a third-party package, run the following:

```shell
% cat<<'EOF' | buildozer -f -
new_load @rules_python//python/entry_points:py_console_script_binary.bzl py_console_script_binary|new py_console_script_binary scriptname|tools:__pkg__
set pkg "@pip//package_name_snake_case"|tools:scriptname
EOF
```

Then edit the new entry in `tools/BUILD` to replace `package_name_snake_case` with the name of the package that exports a console script, and `scriptname` with the name of the script.

>[!NOTE]
>See https://rules-python.readthedocs.io/en/stable/api/python/entry_points/py_console_script_binary.html for more details.## Working with Go modules

After adding a new `import` statement in Go code, run `bazel run gazelle` to update the BUILD file.

If the package is not already a dependency of the project, you have to do some additional steps:

```shell
# Update go.mod and go.sum, using same Go SDK as Bazel (it comes from direnv)
% go mod tidy -v
# Update MODULE.bazel to include the package in `use_repo`
% bazel mod tidy
# Repeat
% bazel run gazelle
```## Stamping release builds

Stamping produces non-deterministic outputs by including information such as a version number or commit hash.

Read more: https://blog.aspect.build/stamping-bazel-builds-with-selective-delivery

To declare a build output which can be stamped, use a rule that is stamp-aware such as
[expand_template](https://docs.aspect.build/rulesets/aspect_bazel_lib/docs/expand_template).

The `/tools/workspace_status.sh` file lists available keys and may include:

- `STABLE_GIT_COMMIT`: the commit hash of the HEAD (current) commit
- `STABLE_MONOREPO_VERSION`: a semver-compatible version in the form `2020.44.123+abc1234`

To request stamped build outputs, add the flag `-config=release`.## Working with Cargo

You can run `cargo` outside of Bazel, using the tool installed on the PATH.

```console
% cargo add reqwest
    Updating crates.io index
      Adding reqwest v0.12.7 to dependencies.
             Features:
             + __tls
             + charset
             + default-tls
             + h2
             + http2
             + macos-system-configuration
             25 deactivated features
    Updating crates.io index
```