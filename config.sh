#!/bin/bash
##
## ** modRana packaging config script **
##

export APP_NAME='modrana'
export APP_VERSION_MAIN='0'
export APP_VERSION_MINOR='48'
export APP_VERSION_BUILD='1'

export LOG_FOLDER_NAME=build_logs
export LOG_FOLDER=${APP_NAME}/${LOG_FOLDER_NAME}/

## add changelog on the lines after
## "APP_CHANGELOG=$( cat <<EOF"
## and before
## "EOF"

export APP_CHANGELOG=$( cat <<EOF
- added persistent overlay configuration support in Qt 5 GUI
- aproximate batch download size is now displayed during batch download in GTK GUI
- location debuging support in Qt 5 GUI
- fixed zoom level not being saved in Qt 5 GUI
- fixed current track logging settings not being displayed properly in GTK GUI
- fixed URL for the Map1.eu map layer
EOF
)
