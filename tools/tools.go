//go:build tools
// +build tools

package tools

// These imports only exist to keep go.mod entries for packages that are referenced in BUILD files,
// but not in Go code.
// See https://github.com/bazel-contrib/rules_go/blob/master/docs/go/core/bzlmod.md#depending-on-tools

import (
	_ "github.com/hay-kot/scaffold" // For code generation
)
