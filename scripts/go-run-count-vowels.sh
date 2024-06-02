#!/bin/bash -e
go run cmd/run-plugin/main.go --wasm target/wasm/release/build/examples/count-vowels/count-vowels.wasm
