#!/bin/bash -ex
moon update && rm -rf target
moon fmt && moon info
# As of moonc v0.6.31+b5b06ff93, `--target native` no longer works.
# moon test --target all
moon test -j 12 --target wasm-gc
moon test -j 12 --target wasm
moon test -j 12 --target js
