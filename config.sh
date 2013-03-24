#!/bin/bash
##
## ** modRana packaging config script **
##

export APP_NAME='modrana'
export APP_VERSION_MAIN='0'
export APP_VERSION_MINOR='40'
export APP_VERSION_BUILD='1'

## add changelog on the lines after
## "APP_CHANGELOG=$( cat <<EOF"
## and before
## "EOF"

export APP_CHANGELOG=$( cat <<EOF
- map overlay support in QML GUI
 - based on a patch by Wikiwide - thanks ! :)
 - multiple overlays can be used at the same time
 - per-layer opacity setting
 - nice overlay configuration UI
 - there is no hard limit on number of overlays at once
  - too many layers at once might slow down the application though :)
 - overlay configuration is not yet persistent
- pretty print map layer loading status
 - also make sure they don't overlap when overlays are used
- long back-button press now returns to map screen
- some new map layers were added to the QML map layer selector
 - eventually it should use the same layer list as the GTK GUI
- fix some warnings at startup
- theme and mode are now exposed by the "modrana" QML context property
EOF
)
