#!/bin/bash -ex

# moon build --target wasm
#
# Due to this current MoonBit issue: https://github.com/moonbitlang/core/issues/480
# it is necessary to replace the "spectest.print_char" external import with an
# internal substitution, so this Go program performs that task:
moon build --target wasm --output-wat
go run cmd/install-spectest-shim/main.go
