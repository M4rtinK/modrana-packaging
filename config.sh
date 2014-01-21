#!/bin/bash
##
## ** modRana packaging config script **
##

export APP_NAME='modrana'
export APP_VERSION_MAIN='0'
export APP_VERSION_MINOR='44'
export APP_VERSION_BUILD='1'

## add changelog on the lines after
## "APP_CHANGELOG=$( cat <<EOF"
## and before
## "EOF"

export APP_CHANGELOG=$( cat <<EOF
- added new Qt5+PyOtherSide based GUI
 - supports multiple QML components sets as backends
 - the Silica component set can be used on Sailfish to provide a native look
 - the Controls set, a post 5.1 Qt built-in, can be used on desktop and elsewhere
 - the GUI is almost fully asynchornous so it should be even more repsonsive than the Qt4 QML GUI
 - much shorter startup time due to PyOtherSide usage
 - based on QtQuick 2.0, so fully hardware accelerated
- new theme named Silica
 - primarily aimed for use on Sailfish OS, but can be also used to provide a slight Sailfish like look on other platforms
- more white monochromatic icons for the Silica and Night themes
- Jolla device module
EOF
)
