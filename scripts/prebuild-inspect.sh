#!/bin/bash

# Build a docker image with python already downloaded inside of it
# so we can iterate on the local compilation as a seperate step!

set -euo pipefail
set -o xtrace

# update latestBuildId in build-local-osx with this so that it cache busts.
# remember to commit this, so that it cache busts for everyone else!!!
#
# we should probably only run update this image via CI, actually...
# and do some kind of blue green deploy???
docker inspect lynncyrin/py-sh-prebuild:latest --format "{{ .Id }}"
