#!/bin/bash -ex

# wasm-gc can be useful for debugging in the browser:
# moon build --target wasm-gc --output-wat
# moon build --target wasm-gc
# moon build --target wasm --output-wat

moon build --target wasm
moon test
