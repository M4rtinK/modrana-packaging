#!/bin/bash
##
## ** modRana packaging config script **
##

export APP_NAME='modrana'
export APP_VERSION_MAIN='0'
export APP_VERSION_MINOR='51'
export APP_VERSION_BUILD='2'

export LOG_FOLDER_NAME=build_logs
export LOG_FOLDER=${APP_NAME}/${LOG_FOLDER_NAME}/

## add changelog on the lines after
## "APP_CHANGELOG=$( cat <<EOF"
## and before
## "EOF"

export APP_CHANGELOG=$( cat <<EOF
- fix tile loading from local storage
 - I've apparently managed to break it in the previous version :P
- make tile loading from local storage more robust
 - it is now file extension independent 
  - modRana will fetch any suitable image for the given tile coordinates
  - this should prevent stored images from becoming inaccessible it layer extension changes
 - modRana now detects if the tile that has been loaded is not an image
  - all such cases are now logged
  - for files modRana tries to find another file with the same coordinates that is an image
- improved log messages for tile loading debugging
EOF
)
