#!/bin/bash

set -euo pipefail
set -o xtrace

name=$1

rm src/docker-run-timestamp.txt || true
docker rm $name -f || true
