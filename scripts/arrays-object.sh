#!/bin/bash -ex
extism call target/wasm/release/build/examples/arrays/arrays.wasm all_three_object --wasi --input "$@"
