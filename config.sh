#!/bin/bash
##
## ** modRana packaging config script **
##

export APP_NAME='modrana'
export APP_VERSION_MAIN='0'
export APP_VERSION_MINOR='53'
export APP_VERSION_BUILD='1'

export LOG_FOLDER_NAME=build_logs
export LOG_FOLDER=${APP_NAME}/${LOG_FOLDER_NAME}/

## add changelog on the lines after
## "APP_CHANGELOG=$( cat <<EOF"
## and before
## "EOF"

export APP_CHANGELOG=$( cat <<EOF
- tile storage and loading should be now much more robust and flexible
- tiles are now looked-up in all available storage methods (files & sqlite)
- simple CLI API for adding POIs to the modRana POI database has been added
- the GTK GUI notifications now handle Unicode and long strings
- some GTK GUI notification timeout fixes
- tile elements should now be properly initialized on startup in Qt 5 GUI
- modRana startup scripts now forward CLI options to the main modRana executable
- verbose tile handling log messages can now be enabled from the Qt 5 GUI
- map layers using the quadkey addressing should now be properly displayed
- Thunderforest map layers have been added
- modRana should now shutdown much more quickly
EOF
)
