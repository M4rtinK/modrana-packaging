#!/bin/bash
##
## ** modRana packaging config script **
##

export APP_NAME='modrana'
export APP_VERSION_MAIN='0'
export APP_VERSION_MINOR='42'
export APP_VERSION_BUILD='1'

## add changelog on the lines after
## "APP_CHANGELOG=$( cat <<EOF"
## and before
## "EOF"

export APP_CHANGELOG=$( cat <<EOF
- add batch tile redownload & update
 - accessible from the "Edit" submenu in batch dl menu
 - redownload ON -> download all tiles, even when locally available
 - redownload OFF (default) -> download only tiles that are not locally available
 - redownload update -> download only tiles that ARE locally available
- add 32bit (i386) Monav routing server binary by jperon - Thanks !
 - this should make offline routing on 32bit x86 machines possible
- preliminary support for high DPI screens in QML GUI
- fix online routing not respecting directions language
- fix tracebacks with some routes from Monav offline routing
EOF
)
