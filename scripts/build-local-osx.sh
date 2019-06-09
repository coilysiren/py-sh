#!/bin/bash

set -euo pipefail
set -o xtrace

repoName=`yq r repo.yml name`
imageName=`yq r repo.yml baseImage`
runningContainersWithMyName=`docker ps --filter "name=$repoName"`
thisPwd=`pwd` # its slightly more readable to store pwd inside a variable

function dockerRun() {
   # run the container
   docker run \
      -itd \
      --network none \
      --name $repoName \
      --volume $thisPwd:$thisPwd \
      --workdir $thisPwd \
      $imageName
   # and set the docker run timestamp
   touch scripts/docker-run-timestamp.txt
}

# check if there is a running containers with my name
if [[ $runningContainersWithMyName =~ $repoName ]]
then
   # there *is* a running containers with my name...
   # so we check to see when it was created,
   # and compare that against the build requirements

   # the 0 value here can be thought of an as "invalid container"
   # essentially a container that was created "never" and therefore
   # should always be re-created
   containerCreationTime=`stat -f %m scripts/docker-run-timestamp.txt || echo "0"`

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
   # there is not* a running containers with my name...
   # so we create one
   dockerRun
fi

# container is up! now we can `docker exec...`
docker exec $repoName scripts/test.sh
