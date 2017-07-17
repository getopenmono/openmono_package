#!/bin/bash

if [[ $# < 1 ]]; then
	echo "ERR: not enough arguments! $#"
	echo "Usage:"
	echo "docker_run.sh [OUTPUT_PATH] [DIST_BRANCH][FRM_BRANCH]"
	exit 1
fi

ENVS=""
if [[ $# -ge 2 ]]; then
	echo "Will use Dist. branch: $2"
	ENVS="-e BRANCH=$2"
fi

if [[ $# -ge 3 ]]; then
	echo "Will use frm. branch: $3"
	ENVS="$ENVS -e FRM_BRANCH=$3"
fi

docker run -ti -v $1:/Desktop $ENVS monolit/package