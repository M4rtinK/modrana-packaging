#!/bin/bash
##
## ** modRana packaging config script **
##

export APP_NAME='modrana'
export APP_VERSION_MAIN='0'
export APP_VERSION_MINOR='41'
export APP_VERSION_BUILD='2'

## add changelog on the lines after
## "APP_CHANGELOG=$( cat <<EOF"
## and before
## "EOF"

export APP_CHANGELOG=$( cat <<EOF
- fix modRana not showing monav routing data packs
- if map folder path is redirected by config file option, the monav routing data folder is also using the redirected path
- new option for disabling (almost) all animations in QML GUI
 - the option is in Options->UI
 - when enabled, page switching becomes ridiculously fast, even on the N900 :)
 - dialog animations are still ON, as there doesn't seem to be a clear way of switching them OFF
EOF
)
