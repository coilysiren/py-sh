#!/bin/bash

set -euo pipefail
set -o xtrace

# push to docker hub
docker push lynncyrin/py-sh-prebuild:latest
