#!/bin/bash -ex
dlv debug cmd/run-plugin/main.go -- --wasm target/wasm/release/build/examples/count-vowels/count-vowels.wasm
