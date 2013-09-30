#!/bin/bash
##
## ** modRana packaging config script **
##

export APP_NAME='modrana'
export APP_VERSION_MAIN='0'
export APP_VERSION_MINOR='43'
export APP_VERSION_BUILD='4'

## add changelog on the lines after
## "APP_CHANGELOG=$( cat <<EOF"
## and before
## "EOF"

export APP_CHANGELOG=$( cat <<EOF
- fix python-protobuf dependency
 - looks newer version is needed for Monav routing server
- only import Monav support once actually needed
 - should shorten startup a little bit
 - in case Monav support fails to load, the route module should still load fine
- use conic based connectivity detection on Fremantle
EOF
)
