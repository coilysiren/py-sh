#!/bin/bash

# Build a docker image with python already downloaded inside of it
# so we can iterate on the local compilation as a seperate step!

set -euo pipefail
set -o xtrace

# create local prebuild image
docker build \
  -f scripts/prebuild-image-dockerfile/Dockerfile \
  -t lynncyrin/py-sh-prebuild:latest \
  scripts/prebuild-image-dockerfile/

# push to docker hub
docker push lynncyrin/py-sh-prebuild:latest

# update latestBuildId in build-local-osx so that it cache busts
# remember to commit this, so that it cache busts for everyone else!!!
# we should probably only run this command via CI, actually...
# and do some kind of blue green deploy???
