#!/bin/bash -ex
extism call target/wasm/release/build/examples/arrays/arrays.wasm progressive_sum_floats --wasi --input "$@"