#!/bin/bash -ex
extism call target/wasm/release/build/examples/arrays/arrays.wasm progressive_concat_strings --wasi --input "$@"
