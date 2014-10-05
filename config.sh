#!/bin/bash
##
## ** modRana packaging config script **
##

export APP_NAME='modrana'
export APP_VERSION_MAIN='0'
export APP_VERSION_MINOR='49'
export APP_VERSION_BUILD='1'

export LOG_FOLDER_NAME=build_logs
export LOG_FOLDER=${APP_NAME}/${LOG_FOLDER_NAME}/

## add changelog on the lines after
## "APP_CHANGELOG=$( cat <<EOF"
## and before
## "EOF"

export APP_CHANGELOG=$( cat <<EOF
- use the Python logging module for all logging in modRana
 - so we now have nice logging levels, module indicators and messages from threads look nice :)
 - also the log file has timestamps and does not mis any early log messages
 - unlike before, log messages are both in log file _and_ in console
 - and the Qt 5 GUI even forwards all log messages to the Python log :)
 - the log file can be enabled and disabled from the Qt 5 GUI
 - there is also full path to the log displayed in the Qt 5 GUI
- it is now possible to use the volume rocker for map zoom on Sailfish OS
- the Options->Map screen in QT 5 GUI now shows path to the map data folder and free space in the folder
- it is now possible to tell modRana to always start in fullscreen
- it is now posible to tell modRana to always show a quit button in the main menu in GTK GUI
- tunables have been exportend for various modRana mechanisms in the GTK GUI
 - the main aim is to enable users to debug or workaround crashes that have been reported on the N900
 - auto dl thread count, batch dl thread count, auto dl queue size, in memory tile cache size, Sqlite tile database commit period
 - use with care and report you findings! :)
- the Sqlite tile database now logs number of commited tiles
- various code cleanum and refactoring
EOF
)
