#!/bin/bash -ex
moon update && moon install && rm -rf target
moon fmt && moon info
# As of moonc v0.6.31+b5b06ff93, `--target native` no longer works.
# moon test --target all
moon test --target wasm-gc
moon test --target wasm
moon test --target js
