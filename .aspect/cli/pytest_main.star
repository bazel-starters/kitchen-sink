"Generate py_pytest_main targets"
aspect.register_rule_kind("py_pytest_main", {
    "From": "@aspect_rules_py//py:defs.bzl",
    "ResolveAttrs": ["deps"],
})

def declare_target(ctx):
    if len(ctx.sources):
        ctx.targets.add(
            kind = "py_pytest_main",
            name = "__test__",
            attrs = {
                "deps": ["@pip//pytest"],
            },
        )

aspect.register_configure_extension(
    id = "pytest_main",
    prepare = lambda cfg: aspect.PrepareResult(
        sources = [
            aspect.SourceGlobs("*_test.py"),
        ],
    ),
    declare = declare_target,
)
