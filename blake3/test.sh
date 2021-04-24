#!/usr/bin/env bash

set -e
DIR=$(dirname $(realpath "$0"))
cd $DIR

deno test --unstable --allow-env --allow-read
