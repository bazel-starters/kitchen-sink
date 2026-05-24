load("@rules_uv//uv:pip.bzl", "pip_compile")

pip_compile(
    name = "runtime",
    requirements_in = "//:pyproject.toml",
    requirements_txt = "runtime.txt",
)

pip_compile(
    name = "requirements.all",
    data = glob([
        "*.in",
        "*.txt",
    ]),
    requirements_in = "all.in",
    requirements_txt = "all.txt",
)
