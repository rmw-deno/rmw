#!/usr/bin/env bash

set -e
DIR=$(dirname $(realpath "$0"))
cd $DIR

deno run --lock=lock.json --lock-write \
  --allow-read --allow-env \
  --unstable mod_test.js

