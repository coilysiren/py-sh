#!/bin/bash

# Build a docker image with python already downloaded inside of it
# so we can iterate on the local compilation as a seperate step!

set -euo pipefail
set -o xtrace

# TODO: something that watches for new python version releases
pythonVersion="3.7.3"

# create local prebuild image
docker build \
  -f scripts/prebuild-dockerfile/Dockerfile \
  -t lynncyrin/py-sh-prebuild:latest \
  --build-arg pythonVersion=$pythonVersion \
  scripts/prebuild-dockerfile/

# update latestBuildId in build-local-osx so that it cache busts
# remember to commit this, so that it cache busts for everyone else!!!
# we should probably only run this command via CI, actually...
# and do some kind of blue green deploy???
docker inspect lynncyrin/py-sh-prebuild:latest --format "{{ .Id }}"

echo "run ./scripts/prebuild-push-image.sh to push the created image"
