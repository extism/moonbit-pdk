#!/bin/bash -ex
extism call \
    target/wasm/release/build/examples/kitchen-sink/kitchen-sink.wasm \
    kitchen_sink \
    --wasi \
    --allow-host='extism.org' \
    --input "$@"
