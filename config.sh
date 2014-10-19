#!/bin/bash
##
## ** modRana packaging config script **
##

export APP_NAME='modrana'
export APP_VERSION_MAIN='0'
export APP_VERSION_MINOR='49'
export APP_VERSION_BUILD='4'

export LOG_FOLDER_NAME=build_logs
export LOG_FOLDER=${APP_NAME}/${LOG_FOLDER_NAME}/

## add changelog on the lines after
## "APP_CHANGELOG=$( cat <<EOF"
## and before
## "EOF"

export APP_CHANGELOG=$( cat <<EOF
- support for keeping screen on for Sailfish OS
 - enabled by default
 - can be turned on/off in Options->UI
- fully asynchronous Qt 5 GUI startup
 - the Qt 5 GUI startup should now be faster and feedback is provided to the user during the whole startup
 - the Bitcon button now works again in the Qt 5 GUI
- the Gratipay donation button has been added to the Qt 5 GUI
- fixed sizes & font sizes of donation buttons
- modRana now supports log file compression with gzip
 - preliminary testing shows about 60% log size reduction when enabled :) 
 - GTK GUI: Options->Debug->Logging
 - Qt 5 GUI: Options->Logging
- print full path to the log file when disabling it
- average speed is now displayed correctly
- add support for passing CLI arguments when using the Qt 5 GUI
- the compass rose in Qt 5 GUI no longer wiggles when pointing close to the northern direction
- fix shutdown handler not triggering on Sailfish OS
- fix Qt GUI log and Qt 5 GUI qml log names
- fix speed statistics centering in Qt 5 GUI
- fix version string wrapping in Qt 5 GUI
EOF
)
