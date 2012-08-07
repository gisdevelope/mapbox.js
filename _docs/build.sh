#!/bin/bash
TAG=$1

if [ -z $TAG ]; then
    echo "Usage: build-site.sh <tag>"
    exit;
fi

if [ -e _posts/$TAG ]; then
    echo "rm -r ../_posts/$TAG if you want to re-build"
    exit;
fi

echo "--- BUILDING mapbox.js $TAG ---"

echo "Creating build/"
mkdir -p build


echo "Installing..."
npm install mapbox.js@$TAG


echo "Generating html..."
node generate.js node_modules/mapbox.js/API.md build/mapboxjs.html
node generate.js node_modules/mapbox.js/node_modules/markers/API.md build/markersjs.html
node generate.js node_modules/mapbox.js/node_modules/easey/API.md build/easey.html 

echo "Creating _posts/api/...$TAG"
sed "s/__TAG__/$TAG/" header > ../_posts/api/0200-01-01-$TAG.html
cat build/mapboxjs.html build/markersjs.html build/easey.html >> ../_posts/api/0200-01-01-$TAG.html

