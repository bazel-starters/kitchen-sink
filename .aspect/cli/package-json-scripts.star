aspect.register_rule_kind("js_binary", {
    "From": "@aspect_rules_js//js:defs.bzl",
})

def declare_targets(ctx):
    for file in ctx.sources:
        if not file.query_results["scripts"][0]:
            continue
        for (script, cmd) in file.query_results["scripts"][0].items():
            # Heuristics to try to understand the structure of a random npm script
            cmd_parts = cmd.split(" ")

            # Looks like it just directly runs an entry point script
            if cmd_parts[0] == "node" and len(cmd_parts) == 2:
                ctx.targets.add(
                    name = script,
                    kind = "js_binary",
                    attrs = {
                        "entry_point": cmd_parts[-1],
                        "data": [":node_modules"],
                    },
                )
            else:
                print("package-json-scripts.star: unable to generate target for {} because command is not a recognized form: {}".format(script, cmd))

aspect.register_configure_extension(
    id = "package-json-scripts",
    prepare = lambda cfg: aspect.PrepareResult(
        sources = [aspect.SourceFiles("package.json")],
        queries = {
            "scripts": aspect.JsonQuery(query = ".scripts?"),
        },
    ),
    declare = declare_targets,
)
