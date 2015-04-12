#!/bin/bash
##
## ** modRana packaging config script **
##

export APP_NAME='modrana'
export APP_VERSION_MAIN='0'
export APP_VERSION_MINOR='52'
export APP_VERSION_BUILD='1'

export LOG_FOLDER_NAME=build_logs
export LOG_FOLDER=${APP_NAME}/${LOG_FOLDER_NAME}/

## add changelog on the lines after
## "APP_CHANGELOG=$( cat <<EOF"
## and before
## "EOF"

export APP_CHANGELOG=$( cat <<EOF
- point to point online routing is now supported in the Qt 5 GUI! :)
 - Frederik Ferner contributed the core Qt 5 GUI routing support code - thanks a lot! :-)
 - routing mode can be activated from the main menu by cliking the "Route" button
  - to end the routing mode, just presss the "clear" button
 - routing parameters can be confiogured in Options->Navigation
  - the car, walking and cycling routing mode can be set
  - avoiding of major highwais and toll roads can be toggled
- GTK GUI should now properly refresh the map when it changes state
 - such as when switching overlays, switching network usage modes, when batch download finsihes, etc.
- you can now double-click the map to zoom in both Qt 5 GUI and GTK GUI
- you can now use the mause wheel to zoom the map in and out in both Qt 5 GUI and GTK GUI
- various statistics are now shown during track recording
- start using PyOtherSide 1.4 and Qt 5.4 for the Android package
 - this should fix a possible PyOtherSide crash at startup and adds Sqlite tile storage support on Android
 - thanks to Qt 5.4 the QtQuick controls (used through UC) now have a native Android theme
 - the compass rose now finally turns - also thanks to Qt 5.4 :)
- use Sqlite tile storage by default on Android
- prevent tile images from being indexed into the gallery on Android
- make the persistent dictionary usage Python 2 & 3 compatible by using the nr. 2 marshal file format
 - this should make it possible to use the Qt 5 GUI (Python 3) and GTK GUI (Python 2) on a single system while sharing a single options file
 - Fedora is one such platform where this is useful
- fix CLI mode
- disable log output to stdout in CLI mode
- Qt 5 GUI map screen performance should now be a bit impoved, as an unexpectedly costly debugging element has been removed
- release media keys when the modRana window is not active on Sauilfish OS
- notifications now work correctly in the Qt 5 GUI
- make QML -> Python log forwarding more robust
- the Qt 5 GUI can now properly use positioning data from GPSD
EOF
)
