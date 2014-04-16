#!/bin/bash
##
## ** modRana packaging config script **
##

export APP_NAME='modrana'
export APP_VERSION_MAIN='0'
export APP_VERSION_MINOR='45'
export APP_VERSION_BUILD='7'

export LOG_FOLDER_NAME=build_logs
export LOG_FOLDER=${APP_NAME}/${LOG_FOLDER_NAME}/

## add changelog on the lines after
## "APP_CHANGELOG=$( cat <<EOF"
## and before
## "EOF"

export APP_CHANGELOG=$( cat <<EOF
- fix the Map1.eu and mtbmap layers not showing up in the map layer menu
EOF
)
