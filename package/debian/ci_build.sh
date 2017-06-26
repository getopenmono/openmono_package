#!/bin/bash

# This shell script is run by the travis CI service
# and executes 2 docker containers:
# 1. The one that builds Mono Framework
# 2. The one that build the SDK package

if [ $# -lt 1 ]; then
	echo "Not enough arguments!"
	echo "Usage:"
	echo "$0 OUTPUT_PATH [PACKAGE_BRANCH]"
	exit 1
fi

OUTPATH=$1
BRANCH=master
FRM_BRANCH=master
if [ $# -gt 1 ]; then
	echo "Setting BRANCH: $2"
	BRANCH=$2
fi

if [ $# -gt 2 ]; then
	echo "Setting FRM_BRANCH: $3"
	FRM_BRANCH=$3
fi

echo "Build framework..."
bash build_frm.sh $OUTPATH && \
bash docker_run.sh $OUTPATH $BRANCH $FRM_BRANCH
