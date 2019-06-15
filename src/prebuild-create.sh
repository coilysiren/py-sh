#!/bin/bash

# Build a docker image with python already downloaded inside of it
# so we can iterate on the local compilation as a seperate step!

set -euo pipefail
set -o xtrace

# TODO: something that watches for new python version releases
pythonVersion="3.7.3"

# create local prebuild image
docker build \
  -f src/prebuild-dockerfile/Dockerfile \
  -t lynncyrin/py-sh-prebuild:latest \
  --build-arg pythonVersion=$pythonVersion \
  src/prebuild-dockerfile/

echo "image built!"

mkdir -p src/generated

docker stop py-sh-prebuild || true
docker rm py-sh-prebuild || true

docker run \
  -itd \
  --network none \
  --name py-sh-prebuild \
  lynncyrin/py-sh-prebuild

docker cp py-sh-prebuild:/assets/python/Makefile "$(pwd)"/src/generated/Makefile

docker stop py-sh-prebuild || true
docker rm py-sh-prebuild || true

echo "makefile copied!"

echo "run ./src/prebuild-push.sh to push the created image"
