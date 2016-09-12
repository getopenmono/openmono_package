#!/bin/bash

VERSION=1.2
DOWNLOAD_URL="https://github.com/getopenmono/openmono_package/releases/download/v$VERSION/openmono_$VERSION.deb"
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

print_status "Installing the OpenMono v$VERSION..."

# # Populating Cache
print_status "Populating apt-get cache..."
exec_cmd 'apt-get update  > /dev/null 2>&1'

print_status "Getting add-apt-repositoty..."
exec_cmd "apt-get install -y software-properties-common python-software-properties > /dev/null 2>&1"

print_status "Adding PPA key for GCC ARM Embedded repo..."
exec_cmd_nobail "add-apt-repository -y ppa:team-gcc-arm-embedded/ppa"

print_status "Updating apt-get cache again..."
exec_cmd "apt-get update > /dev/null 2>&1"

#print_status "Installing GCC ARM Embedded..."
#exec_cmd "apt-get -y install gcc-arm-embedded"

print_status "Downloading OpenMono package..."
exec_cmd "curl -Lo $FILENAME ${DOWNLOAD_URL}"

print_status "Installing OpenMono..."
exec_cmd_nobail "dpkg -i openmono_$VERSION.deb"

print_status "Installing dependencies..."
exec_cmd_nobail "apt-get -f -y install > /dev/null 2>&1"

exec_cmd_nobail "pip install pyserial"

exec_cmd_nobail "rm ${FILENAME}"

print_status "All done"
print_status "To remove again type: sudo aptitude remove OpenMono"
