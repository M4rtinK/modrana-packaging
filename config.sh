#!/bin/bash
##
## ** modRana packaging config script **
##

export APP_NAME='modrana'
export APP_VERSION_MAIN='0'
export APP_VERSION_MINOR='49'
export APP_VERSION_BUILD='7'

export LOG_FOLDER_NAME=build_logs
export LOG_FOLDER=${APP_NAME}/${LOG_FOLDER_NAME}/

## add changelog on the lines after
## "APP_CHANGELOG=$( cat <<EOF"
## and before
## "EOF"

export APP_CHANGELOG=$( cat <<EOF
- fix the compass rose not showing up in the Qt 5 GUI on Sailfish OS
- fix a typo preventing location startup if no last known position exists in Qt 5 GUI
- fix a race condition that could prevent some map tiles from working properly in Qt 5 GUI
EOF
)
