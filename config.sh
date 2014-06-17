#!/bin/bash
##
## ** modRana packaging config script **
##

export APP_NAME='modrana'
export APP_VERSION_MAIN='0'
export APP_VERSION_MINOR='47'
export APP_VERSION_BUILD='2'

export LOG_FOLDER_NAME=build_logs
export LOG_FOLDER=${APP_NAME}/${LOG_FOLDER_NAME}/

## add changelog on the lines after
## "APP_CHANGELOG=$( cat <<EOF"
## and before
## "EOF"

export APP_CHANGELOG=$( cat <<EOF
- add local search support to the Qt 5 GUI
- sort local search results by initial distance in Qt 5 GUI
- show search results on the map in Qt 5 GUI
- highlight the result that was selected in result list in red on map in Qt 5 GUI
EOF
)
