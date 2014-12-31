#!/bin/bash
##
## ** modRana packaging config script **
##

export APP_NAME='modrana'
export APP_VERSION_MAIN='0'
export APP_VERSION_MINOR='50'
export APP_VERSION_BUILD='1'

export LOG_FOLDER_NAME=build_logs
export LOG_FOLDER=${APP_NAME}/${LOG_FOLDER_NAME}/

## add changelog on the lines after
## "APP_CHANGELOG=$( cat <<EOF"
## and before
## "EOF"

export APP_CHANGELOG=$( cat <<EOF
* layer timeout support (Frederic Ferner)
 * dynamic map layers (traffic, weather, etc.) now automatically load new tiles once the oled ones time out
 * not yet handles staring at the same part of map for hours
 * you need to move the map a bit so that the tiles are requested again & refetched
* support for setting network usage mode in Qt 5 GUI (Frederic Ferner)
 * max - unlimited network usage
 * minimal - no automatic tile download
* Thanks a lot to Frederic for these nice two patches! :)
* fix text sizing on icon grid
* fix compass rose display with qrc (Android)
 * it still does not rotate on Android some reason :)
EOF
)
