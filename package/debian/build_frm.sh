#!/bin/bash

# This shell script runs the docker container that builds the Mono Framework
#  and copies the results to a configurable destination

source ../configuration.sh

if [ ! $FRM_BRANCH ]; then FRM_BRANCH="master"; fi
if [ ! $FRM_DOCKER_IMAGE ]; then FRM_DOCKER_IMAGE="monolit/monofrm"; fi

if [ $# -lt 1 ]; then
	echo "ERROR: missing input params!"
	echo "Usage:"
	echo "$0 DEST_DIR [FRM_BRANCH]"
	exit 1
fi

FRM_DEST=$1

if [ $# -gt 1 ]; then
	FRM_BRANCH=$2
fi

echo "Using Docker img. $FRM_DOCKER_IMAGE, to pull branch $FRM_BRANCH and copy build to $FRM_DEST"

docker pull $FRM_DOCKER_IMAGE && \
docker run -tie DEPLOY=true -e BRANCH=$FRM_BRANCH -v $FRM_DEST:/Desktop $FRM_DOCKER_IMAGE
