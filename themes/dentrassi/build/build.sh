#!/usr/bin/env bash

set -e

rsync -r node_modules/@fontsource/jost/files/ ../static/files/

# we don't copy the icons, we embed the SVG
