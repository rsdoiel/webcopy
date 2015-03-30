#!/bin/bash
#
# From the webcopy.sh version of housingprototypes.org rebuild a cleaned up
# version of the website in a static directory.
#

function usage() {
    echo 'USAGE: ./build-static-site.sh SITE_COPY_DIRECTORY_NAME'
    echo ''
    echo '   If http://example.com is saved locally by wget as example.com'
    echo '   then'
    echo ''
    echo '        ./build-static-site example.com'
    echo ''
    exit 1;
}

function makeDirectories() {
    START_DIR=$1
    echo 'Building directories '
    find $START_DIR -type d | while read ITEM; do
        echo -n "."
        NEW_DIR=${ITEM/$START_DIR/static}
        mkdir -p "$NEW_DIR"
    done
    echo ' done.'
}

function initialize() {
    if [ -f ./fext ] && [ -f ./inarray ]; then
        echo 'Ready to go.'
    else
        echo 'Building go utilities'
        make
        echo ' done.'
    fi
    if [ -d ./static ]; then
        rm -fR ./static/*
    fi
}

#
# Main logic.
#
if [ "$1" = "" ]; then
    usage
fi
initialize
makeDirectories $1

