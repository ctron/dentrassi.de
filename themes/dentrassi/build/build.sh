#!/usr/bin/env bash

set -e

rsync -r node_modules/@fontsource/jost/files/ ../static/files/
mkdir -p ../static/js/
cp node_modules/bootstrap/dist/js/bootstrap.bundle.min.js ../static/js/

# we don't copy the icons, we embed the SVG
