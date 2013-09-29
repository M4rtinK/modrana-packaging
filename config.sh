#!/bin/bash
##
## ** modRana packaging config script **
##

export APP_NAME='modrana'
export APP_VERSION_MAIN='0'
export APP_VERSION_MINOR='43'
export APP_VERSION_BUILD='3'

## add changelog on the lines after
## "APP_CHANGELOG=$( cat <<EOF"
## and before
## "EOF"

export APP_CHANGELOG=$( cat <<EOF
- don't crash if a filesystem path can't be created
- fix online routing not respecting route parameters
 - current mode is now correctly taken into account
 - "avoid highways" and "avoid toll roads" works correctly again
- convert Wikipedia search to the new asynchronous provider framework
- convert local search to the new asynchronous provider framework
- address, wikipedia and local search wait for Internet connectivity
 - and enable it if needed
- local search also waits for GPS, if needed
 - and will enable it, provided it is not turned of in options
- local search now intializes GPS and Internet in parallel
 - this should speed up local search triggered from CLI
 - provided GPS and Internet is not yet initialized when triggered
- CLI search debugging option
 - disables stdout suppression
- add (hopefully) cross platform connectivity checking
- the "search" button in the Fremantle app menu on the N900 now goes to the main search page
- the modRana standard output now contains current Python version during startup
 - for easier debugging of Python version sepcific issues
- fix routing to local search results
- make "clear results" work for Address and Wikipedia search results
- make "clear all" in the main search menu clear all results
- tile storage type can now be selected in the QML GUI
 - in Options->Map
- add a directions fix from Geoff Kuenning - thanks! :)
EOF
)
