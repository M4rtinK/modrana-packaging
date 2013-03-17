#!/bin/bash
##
## ** modRana packaging config script **
##

export APP_NAME='modrana'
export APP_VERSION_MAIN='0'
export APP_VERSION_MINOR='39'
export APP_VERSION_BUILD='9'

## add changelog on the lines after
## "APP_CHANGELOG=$( cat <<EOF"
## and before
## "EOF"

export APP_CHANGELOG=$( cat <<EOF
- massive map layer update ! :)
 - new OpenStreetMap layers
  - Mapnik b/w
  - Landscape
  - no labels
  - labels (en)
  - Hike and Bike
  - OpenTopoMap
  - Land Shading
 - CloudMade Layers
  - The Original
  - Fine Line
  - Red Alert
  - Midnight Commander
  - Fresh
  - No-Names (shows unnamed roads and streats in OSM)
  - Pale Dawn
  - Tourist
  - Blackout
  - Thin
  - Cycle Walk
 - CloudMade 2x
  - same layers, double-sized text and roads
  - good for high-DPI screens
 - Freemap.sk
  - autoatlas
  - touristic
  - cyklomap
  - skimap
  - public transit
 - new Google layers
  - traffic
  - traffic overlay
  - traffic overlay labeled
  - public transit
  - weather Clesius
  - weather Fahrenheit
  - terrain
  - terrain only (no labels)
 - Czech layers
  - amapy Tourist layer
 - OpenSignal (mobile networg coverage)
  - all overlay
 - Yandex
  - maps
  - satellite
  - overlay
- added new coordinate tile coordinate substitution method
EOF
)