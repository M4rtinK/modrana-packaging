#!/bin/bash
##
## ** modRana packaging config script **
##

export APP_NAME='modrana'
export APP_VERSION_MAIN='0'
export APP_VERSION_MINOR='46'
export APP_VERSION_BUILD='1'

export LOG_FOLDER_NAME=build_logs
export LOG_FOLDER=${APP_NAME}/${LOG_FOLDER_NAME}/

## add changelog on the lines after
## "APP_CHANGELOG=$( cat <<EOF"
## and before
## "EOF"

export APP_CHANGELOG=$( cat <<EOF
- local search works again thanks to a patch provided by Geoff Kuenning - thanks a lot ! :)
- it is now possible to set local search radius in the GTK GUI (in options and directly in the search menu with a toggle button)
- map display and dragging should now be faster
- automatic map tile downloading has been rewritten and should be now more efficient
- batch tile download has been rewritten and improved - should be now more efficient and faster
- the tile hnadling code is now in much better shape overall
- the batch tile menu in GTK GUI no longer lags and has a more logical structure
- fix tile downloading not working in Sailfish GUI due to Python 3.4 breaking old bundled version of Urllib 3
EOF
)
