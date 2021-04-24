#!/usr/bin/env bash

set -e

_DIR=$(dirname $(realpath "$0"))

cd $_DIR
# ls ~/.rustup/toolchains
# rustup default 1.5.0-x86_64-apple-darwin
cargo build --release
ssvmup build --release --target deno
rm pkg/.gitignore

