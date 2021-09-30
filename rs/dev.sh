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

rsync -av os/js/* src

exec npx nodemon --watch 'test/**/*' --watch 'src/**/*' -e coffee,js,mjs,json,wasm,txt,yaml --exec ".direnv/bin/dev.sh $exe"
