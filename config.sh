#!/bin/bash
##
## ** modRana packaging config script **
##

export APP_NAME='modrana'
export APP_VERSION_MAIN='0'
export APP_VERSION_MINOR='50'
export APP_VERSION_BUILD='5'

export LOG_FOLDER_NAME=build_logs
export LOG_FOLDER=${APP_NAME}/${LOG_FOLDER_NAME}/

## add changelog on the lines after
## "APP_CHANGELOG=$( cat <<EOF"
## and before
## "EOF"

export APP_CHANGELOG=$( cat <<EOF
- make it possible to show the back button on Sailfish OS
 - can be enabled from Options->UI
- fix Sqlite tile storage with Qt 5 GUI
- fix the Animate switch to work correctly on Sailfish OS
- fix a few page push transitions that have not respected the animation setting in Qt 5 GUI
- fix back button in the detail menu of a POI restored on startup breaking the GTK GUI
- use proper logging during batch tile download 
EOF
)
