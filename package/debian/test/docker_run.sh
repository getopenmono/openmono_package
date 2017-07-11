#!/bin/bash

if [ $# -lt 1 ]; then
    echo "Missing args!"
    echo "Usage: docker_run.sh [DEB_FILE_OR_LINK]"
    exit 1
fi

function setAbsolutePath {
    ABS_PATH=$1
    if [ `expr "$ABS_PATH" : '/\(.*\)'` ]; then
        echo "Absolute"
        ABS_PATH=$ABS_PATH
    else
        echo "Relative"
        ABS_PATH=`pwd`/$ABS_PATH
    fi
}

if [ -f $1 ]; then
    echo "File mode"
    setAbsolutePath $1
    echo "Path: $ABS_PATH"
    FILENAME="${ABS_PATH##*/}"
    DIRNAME="${ABS_PATH%/*}"
    echo "Dir: $DIRNAME, file: $FILENAME"
    docker run -tie SCRIPT_IS_FILE=true -e INSTALL_SCRIPT=/Desktop/$FILENAME -v $DIRNAME:/Desktop monolit/debtest
elif [ `expr "$1" : 'http\(.*\)'` ]; then
    echo "Internet link"
    docker run -tie INSTALL_SCRIPT=$1 monolit/debtest
else
    echo "$1 does not exist"
    exit 1
fi