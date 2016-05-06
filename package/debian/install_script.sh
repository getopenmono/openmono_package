#!/bin/bash

GPG_KEY=http://ppa.launchpad.net/team-gcc-arm-embedded/ppa/ubuntu/dists/precise/Release.gpg

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

print_status "Installing Mono Developer Environment..."
print_status 'Adding the Team GCC Arm Embedded signing key to your keyring...'

if [ -x /usr/bin/curl ]; then
    exec_cmd "curl -s ${GPG_KEY} | apt-key add -"
else
    exec_cmd "wget -qO- ${GPG_KEY} | apt-key add -"
fi

