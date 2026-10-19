#!/bin/bash -ex
extism call target/wasm/release/build/examples/add/add.wasm add --wasi --input "$@"
