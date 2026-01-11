"""BUILD definition for the formatter binary

This is in its own package because it has so many loading-time symbols,
we don't want to trigger eager fetches of these for builds that don't want to run format.
"""

load("@aspect_rules_lint//format:defs.bzl", "format_multirun")
load("@npm//:prettier/package_json.bzl", prettier = "bin")
load("@rules_java//java:java_binary.bzl", "java_binary")

# gazelle:exclude
package(default_visibility = ["//:__subpackages__"])

prettier.prettier_binary(
    name = "prettier",
    # Include this js_library and its dependencies in the runfiles (runtime dependencies)
    data = ["//:prettierrc"],
    # Allow the binary to be run outside bazel
    env = {"BAZEL_BINDIR": "."},
    fixed_args = [
        # `require` statements in the config file will be resolved relative to its location
        # Therefore to make it hermetic, prettier must be pointed at the copy of the config file
        # in the runfiles folder rather than the one in the source folder.
        "--config=\"$$JS_BINARY__RUNFILES\"/$(rlocationpath //:prettierrc)",
        # default log level is "log" which spams on success
        # https://prettier.io/docs/en/cli.html#--log-level
        "--log-level=warn",
    ],
)

java_binary(
    name = "ktfmt",
    main_class = "com.facebook.ktfmt.cli.Main",
    runtime_deps = ["@ktfmt//jar"],
)

format_multirun(
    name = "format",
    cc = "@llvm_toolchain_llvm//:bin/clang-format",
    go = "@aspect_rules_lint//format:gofumpt",
    javascript = ":prettier",
    kotlin = ":ktfmt",
    python = "@aspect_rules_lint//format:ruff",
    rust = "@rules_rust//tools/rustfmt:upstream_rustfmt",
    shell = "@aspect_rules_lint//format:shfmt",
    starlark = "@buildifier_prebuilt//:buildifier",
)
