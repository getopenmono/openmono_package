#!/bin/bash

if [[ $# < 1 ]]; then
	echo "ERR: not enough arguments! $#"
	echo "Usage:"
	echo "docker_run.sh [OUTPUT_PATH]"
	exit 1
fi

docker run -ti -v $1:/Desktop monobuild