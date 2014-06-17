#!/bin/bash
##
## ** modRana packaging config script **
##

export APP_NAME='modrana'
export APP_VERSION_MAIN='0'
export APP_VERSION_MINOR='47'
export APP_VERSION_BUILD='1'

export LOG_FOLDER_NAME=build_logs
export LOG_FOLDER=${APP_NAME}/${LOG_FOLDER_NAME}/

## add changelog on the lines after
## "APP_CHANGELOG=$( cat <<EOF"
## and before
## "EOF"

export APP_CHANGELOG=$( cat <<EOF
- the QtQuick GUI now downloads new tiles asynchronously
 - much faster asynchronous tile loading !
 - no more synchronous tile download stalls !
 - no more GUI freezes when starting modRana without connectivity !
 - tiles currently on the screen have a diwnload priority (LiFo download queue)
 - if the queue is full, old download requests that are probably no longer visible are dropped
 - proper tile download error hanling & retry support
 - proper tile download feedback
 - tile handling debug support
- fix tiles stuck on "Downloading"/"Loading" in GTK GUI
- fix weird tile loading artifacts in overlay mode in the GTK GUI
- remove all Cloudmade layers as they were discontinue in the first half of May
- change Sailfish OS profile folder name to harbour-modrana and migrate all data to the new folders
 - this is fully automatic and no user interaction is needed
 - this makes modRana Harbour compliant in regards to profile paths
EOF
)
