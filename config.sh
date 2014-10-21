#!/bin/bash
##
## ** modRana packaging config script **
##

export APP_NAME='modrana'
export APP_VERSION_MAIN='0'
export APP_VERSION_MINOR='49'
export APP_VERSION_BUILD='6'

export LOG_FOLDER_NAME=build_logs
export LOG_FOLDER=${APP_NAME}/${LOG_FOLDER_NAME}/

## add changelog on the lines after
## "APP_CHANGELOG=$( cat <<EOF"
## and before
## "EOF"

export APP_CHANGELOG=$( cat <<EOF
- generate correct (Python 3.4) bytecode for the Sailfish OS package
 - makes modRana Python part startup almost 2 times faster (~3.8s->~2s) ! :)
- make location and map page in Qt 5 GUI asynchronous
 - this should make the startup even faster and more seemless
- add a fade in & out animation for the startup indicator in Qt 5 GUI
EOF
)
