#!/usr/bin/env bash
set -e
DIR=$( dirname $(realpath "$0") )

cd $DIR
. .direnv/bin/pid.sh

if [ ! -n "$1" ] ;then
exe=src/index.coffee
else
exe=${@:1}
fi

rm -rf src/__dirname.coffee
ln -s __dirname.js.coffee src/__dirname.coffee

exec npx nodemon --watch 'test/**/*' --watch 'src/**/*' -e coffee,js,mjs,json,wasm,txt,yaml --exec ".direnv/bin/dev.sh $exe"
