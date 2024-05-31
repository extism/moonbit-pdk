#!/bin/bash -e
extism call target/wasm-gc/release/build/examples/greet/greet.wasm greet --wasi --input "$@" || echo $?
echo ''
echo $?
