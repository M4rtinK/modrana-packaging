#!/bin/bash
##
## ** modRana packaging config script **
##

export APP_NAME='modrana'
export APP_VERSION_MAIN='0'
export APP_VERSION_MINOR='40'
export APP_VERSION_BUILD='2'

## add changelog on the lines after
## "APP_CHANGELOG=$( cat <<EOF"
## and before
## "EOF"

export APP_CHANGELOG=$( cat <<EOF
- add new coordinate substitution method for layers using quadtree/quadkey addressing
- add the VE UKOS layer
EOF
)
