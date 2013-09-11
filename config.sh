#!/bin/bash
##
## ** modRana packaging config script **
##

export APP_NAME='modrana'
export APP_VERSION_MAIN='0'
export APP_VERSION_MINOR='43'
export APP_VERSION_BUILD='2'

## add changelog on the lines after
## "APP_CHANGELOG=$( cat <<EOF"
## and before
## "EOF"

export APP_CHANGELOG=$( cat <<EOF
- fix the annoying "Xlib: unexpected async reply" error
 - thanks to Geoff Kuening for helping to find the root cause ! :)
- fix navigation messages when using Monav offline routing
 - no more "None to First Street" :)
- fix route OSD menu
- reverse geocoding now uses Nominatim instead of Google
- start and destination address display takes aspect ratio into account
EOF
)
