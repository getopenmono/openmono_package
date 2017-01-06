#!/bin/bash

VERSION=1.5.0
GIT_TAG="SDKv1_5"
DOWNLOAD_URL="https://github.com/getopenmono/openmono_package/releases/download/$GIT_TAG/openmono_$VERSION.deb"
FILENAME=`basename $DOWNLOAD_URL`
export DEBIAN_FRONTEND=noninteractive

print_status() {
    echo
    echo "## $1"
    echo
}

bail() {
    echo 'Error executing command, exiting'
    exit 1
}

exec_cmd_nobail() {
    echo "+ $1"
    bash -c "$1"
	
}

exec_cmd() {
    exec_cmd_nobail "$1" || bail
}

print_status "Installing the OpenMono $VERSION..."

print_status "Downloading OpenMono package..."
exec_cmd "curl -Lo $FILENAME ${DOWNLOAD_URL}"

print_status "Installing OpenMono..."
exec_cmd_nobail "dpkg -i openmono_$VERSION.deb"

print_status "Installing dependencies..."
exec_cmd_nobail "apt-get -f -y install"

exec_cmd_nobail "pip install pyserial"

exec_cmd_nobail "rm ${FILENAME}"

print_status "All done"
print_status "To remove again type: sudo aptitude remove OpenMono"
