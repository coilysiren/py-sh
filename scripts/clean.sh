#!/bin/bash

set -euo pipefail
set -o xtrace

repoName='py-sh'

rm scripts/docker-run-timestamp.txt || true
docker rm $repoName -f || true
