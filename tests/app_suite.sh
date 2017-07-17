#!/bin/bash

TEST_APPS="
https://github.com/getopenmono/alarmclock.git
https://github.com/getopenmono/templog.git
https://github.com/getopenmono/chores.git
https://github.com/getopenmono/accelBeep.git
https://github.com/getopenmono/temperature.git
https://github.com/getopenmono/simpletemp.git
https://github.com/getopenmono/pong.git"

# Run kiosk apps

function bail {
    echo "$1 failed"
    exit 1
}

function buildApp {
    FILENAME="${1##*/}"
    FOLDER="${FILENAME%.*}"
    echo "Testing: $FOLDER"
    if [ -d testApps/$FOLDER ]; then rm -rf testApps/$FOLDER; fi
    git clone $1 testApps/$FOLDER || exit 1
    if [ -f testApps/$FOLDER/Makefile.dist ]; then
        echo "Using Makefile.dist"
        make -C testApps/$FOLDER -f Makefile.dist || bail $FOLDER
    elif [ -f testApps/$FOLDER/Makefile.lib ]; then
        echo "Using Makefile.lib"
        make -C testApps/$FOLDER -f Makefile.lib || bail $FOLDER
    else
        make -C testApps/$FOLDER || bail $FOLDER
    fi
}

echo "Testing existing apps from GitHub..."
IFS=$'\n'
for url in $TEST_APPS; do
    buildApp $url
done

echo "Success!! :-D"
echo "deleting apps dir"
rm -rf testApps
exit 0