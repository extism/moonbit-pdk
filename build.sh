#!/bin/bash -ex

# wasm-gc can be useful for debugging in the browser:
# moon build --target wasm-gc --output-wat
# moon build --target wasm-gc

# Due to this current MoonBit issue: https://github.com/moonbitlang/core/issues/480
# it is necessary to replace the "spectest.print_char" external import with an
# internal substitution, so this Go program performs that task (in addition to
# working around an odd MoonBit compiler bug):
moon build --target wasm --output-wat
go run cmd/install-spectest-shim/main.go --watflags="--debug-names"
