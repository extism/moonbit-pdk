#!/bin/bash -e
extism call target/wasm/release/build/examples/count-vowels/count-vowels.wasm count_vowels --wasi --input "$@"
extism call target/wasm/release/build/examples/greet/greet.wasm greet --wasi --input "$@"
