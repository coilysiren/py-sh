#!/bin/bash

# This script sets up a local build environment meant for rapid iteration
# that matches the containerized build that'll be happening on CircleCI.

set -euo pipefail
set -o xtrace

# Anything that could change the output of `make build` needs to be
# denormalized into this file. Some variables (like latestBuildId) in
# this file are purely used for cache busting.
#
# latestBuildId specifically... we should be able to fetch from docker hub,
# and then manually add a cache busting check?
repoName='py-sh'
imageName='lynncyrin/py-sh-prebuild:latest'
latestBuildId='sha256:77bd6a0a2f86951f840bd34f97a33c7cb1bf3c417ec5f64f5feda4baccbd87a3'
runningContainersWithOurName=`docker ps --filter "name=$repoName"`

function dockerRun() {
   # run the container
   docker run \
      -itd \
      --network none \
      --name $repoName \
      --mount type=bind,src=`pwd`,dst=/repo \
      --workdir /repo \
      $imageName
   # and set the docker run timestamp
   touch scripts/docker-run.timestamp.txt
}

# check if there is a running containers with our name
if [[ $runningContainersWithOurName =~ $repoName ]]
then
   # there *is* a running containers with our name...
   # so we check to see when it was created,
   # and compare that against the build requirements

   # the 0 value here can be thought of an as "invalid container"
   # essentially a container that was created "never" and therefore
   # should always be re-created
   containerCreationTime=`stat -f %m scripts/docker-run.timestamp.txt || echo "0"`

   # when was the build script last modified?
   #
   # there's other things we should check (like the image name, and the repo name?)
   # but that's TODO. for now, run a `make clean` if you change anything weird
   buildScriptModificationTime=`stat -f %m scripts/build-local-osx.sh`

   # check if the build script has been modified since the container was created
   if [[ $buildScriptModificationTime -ge $containerCreationTime ]]
   then
      # the build script *was* modified since the container was created...
      # so we need to reset the container
      docker rm $repoName -f
      dockerRun
   fi

else
   # there is *not* a running container with our name...
   # so we create one
   dockerRun
fi

# container is up! now we can `docker exec...`
docker exec $repoName scripts/build.sh
