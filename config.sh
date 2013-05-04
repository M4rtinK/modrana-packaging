#!/bin/bash
##
## ** modRana packaging config script **
##

export APP_NAME='modrana'
export APP_VERSION_MAIN='0'
export APP_VERSION_MINOR='40'
export APP_VERSION_BUILD='3'

## add changelog on the lines after
## "APP_CHANGELOG=$( cat <<EOF"
## and before
## "EOF"

export APP_CHANGELOG=$( cat <<EOF
- GTK GUI: potentially faster automatic & batch tile download
 - and other activities, such as online lookups, that use threads
 - looks like gobject.init_threads() and gtk.init_threads() was not called before gtk.main()
 - as result, Python threads might have run only when some GTK events happened
 - this would explain why modRana sometimes downloaded tiles slower with blanked screen
- QML GUI: new nested map layer selection dialog that shows all layers
 - it now shares with the GTK GUI the same data model
 - as result, both GUI now should show the same list of layers
EOF
)
