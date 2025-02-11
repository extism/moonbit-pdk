#!/bin/bash -ex
moon update && moon install && rm -rf target
moon fmt && moon info
moon test --target all
