#!/bin/bash -ex
extism call target/wasm/release/build/examples/greet/greet.wasm greet --wasi --input "$@"
