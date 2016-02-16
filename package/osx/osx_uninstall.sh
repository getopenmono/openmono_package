#!/bin/bash

LOCATION=/usr/local/openmono
SYMLINK=/usr/local/bin/monomake
USER=`whoami`

if [ ! $USER == "root" ]; then
	echo "ERR: You must be a sudo'er to uninstall OpenMono"
	exit 1
fi

if [ -d $LOCATION ]; then
	echo "Removing OpenMono..."
	rm -rf $LOCATION
else
	echo "OpenMono does not seem to be installed"
fi

if [ -e $SYMLINK -o -L $SYMLINK ]; then
	echo "Removing symlink from path..."
	rm $SYMLINK
fi