#!/usr/bin/env bash

_DIR=$(cd "$(dirname "$0")"; pwd)
cd $_DIR
rsync -av os/exe/* src
npm run prepare
deno bundle --unstable --import-map=.import.map.json ./lib/index.js > ./lib/rmw-srv.js
deno compile --location https://rmw.link -A --unstable lib/rmw-srv.js

# npx terser --source-map --mangle --compress --module -o rmw-srv.js -- ./lib/rmw-srv.js

# version=$(cat package.json|jq -r '.version')
# git commit -m $version
# npm set unsafe-perm true
# npm version patch
# npm publish --access=public
# sync
