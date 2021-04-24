#!/usr/bin/env bash

set -e
DIR=$(dirname $(realpath "$0"))
cd $DIR

deno run --lock=lock.json --lock-write \
  -A \
  --unstable mod_test.js

