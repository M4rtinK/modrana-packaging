#!/bin/bash
##
## ** modRana packaging config script **
##

export APP_NAME='modrana'
export APP_VERSION_MAIN='0'
export APP_VERSION_MINOR='51'
export APP_VERSION_BUILD='1'

export LOG_FOLDER_NAME=build_logs
export LOG_FOLDER=${APP_NAME}/${LOG_FOLDER_NAME}/

## add changelog on the lines after
## "APP_CHANGELOG=$( cat <<EOF"
## and before
## "EOF"

export APP_CHANGELOG=$( cat <<EOF
- add track logging support to the Qt 5 GUI
 - accessible from Tracks->Record
 - output to the GPX format
 - path to the tracklogs folder is shown
  - option to symlink the tracklogs folder to ~/Documents on Sailfish OS
 - robust dual temp file storage mechanism
 - tracklog are restored on next start if shutdown or crash occurs during logging
 - it is possible to pause started logging
 - proper landscape and protrait orientation layouts
 - keep alive support on Sailfish OS
  - this should assure uninterrupted track recording even with screen turned off
- make track logging Python 3 compatible
- improved track logging log messages
- fix free space dispplay on Android
- QML -> Python logging now should be able to handle any QML/Javascript objects
EOF
)
