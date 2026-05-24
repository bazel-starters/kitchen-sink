"go_image macro for OCI containers"

load("@bazel_lib//lib:transitions.bzl", "platform_transition_filegroup")
load("@rules_oci//oci:defs.bzl", "oci_image", "oci_load")
load("@tar.bzl", "tar")

def go_image(name, binary, base = "@distroless_base"):
    tar(
        name = name + "_app_layer",
        srcs = [binary],
        mtree = [
            "./opt/app type=file content=$(execpath {})".format(binary),
        ],
    )
    oci_image(
        name = name,
        base = base,
        tars = [
            name + "_app_layer",
        ],
        entrypoint = [
            "/opt/app",
        ],
    )
    platform_transition_filegroup(
        name = name + "_platform",
        srcs = [name],
        target_platform = select({
            "@platforms//cpu:arm64": "@rules_go//go/toolchain:linux_arm64",
            "@platforms//cpu:x86_64": "@rules_go//go/toolchain:linux_amd64",
        }),
    )
    oci_load(
        name = name + ".load",
        image = name + "_platform",
        repo_tags = [
            native.package_name() + ":latest",
        ],
    )
