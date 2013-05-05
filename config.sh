#!/bin/bash
##
## ** modRana packaging config script **
##

export APP_NAME='modrana'
export APP_VERSION_MAIN='0'
export APP_VERSION_MINOR='41'
export APP_VERSION_BUILD='1'

## add changelog on the lines after
## "APP_CHANGELOG=$( cat <<EOF"
## and before
## "EOF"

export APP_CHANGELOG=$( cat <<EOF
- modRana is now Python 3 compatible
 - Python 2.5 compatibility was of course preserved
 - as a result, modRana still works just fine with Python 2.5 on the N900
 - Python 3 compatibility should enable packaging modRana for BlackBerry 10
- Android compatibility
 - modRana with the QML GUI now works on Android
 - Android device module has been added
 - installable APKs are available
 - APK generation script was added to the modRana packaging scripts
 - map data are stored in /sdcard/modrana/maps
- QML GUI improvements
 - theme switching support
 - night theme for the QML GUI
 - the menu button can now show current mode, as in GTK GUI
 - thanks to Wikiwide for the idea & icons ! :)
 - finally some buttons in Options (related to theme switching & menu icon configuration)
 - fixed centering to the middle of the Atlantic at startup (center on Brno instead :) )
 - fixed main map icon now shows only one map layer
- automatic tile downloading in GTK GUI should now be faster due to connection reuse provided by Urllib 3
- new POI icon
- various fixes
EOF
)
