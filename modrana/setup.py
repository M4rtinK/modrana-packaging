#!/usr/bin/env python
# -*- coding: utf-8 -*-

# modRana setup.py

import glob, re

import sys
import time

reload(sys).setdefaultencoding("UTF-8")

# check for startup arguments
if len(sys.argv) < 2:
  print("Error: build target not specified")
  print("use sdist_ubuntu, sdist_harmattan or sdist_fremantle")
  sys.exit(1)

TARGET = sys.argv[1]
if TARGET not in ["sdist_harmattan", "sdist_fremantle"]:
  print("Error, wrong target specified")
  print("use sdist_ubuntu, sdist_harmattan or sdist_fremantle")
  sys.exit(2)

import os

try:
  from sdist_maemo import sdist_maemo as _sdist_maemo
  sdist_maemo = _sdist_maemo
except ImportError:
  sdist_maemo = None
  print('sdist_maemo command not available')

from distutils.core import setup

def read(fname):
  if os.path.exists(fname):
    return open(os.path.join(os.path.dirname(__file__), fname)).read()
  else:
    return ""

## Constants ##

APP_NAME="modrana"
PRETTY_APP_NAME="modRana"
AUTHOR="Martin Kolman"
AUTHOR_EMAIL="martin.kolman@gmail.com"
# in this case: author = maintainer
MAINTAINER = AUTHOR
MAINTAINER_EMAIL = AUTHOR_EMAIL
VERSION=read("version").strip("\n")
BUILD="0"
DESKTOP_FILE_PATH="/usr/share/applications"
FREMANTLE_DESKTOP_FILE_PATH = os.path.join(DESKTOP_FILE_PATH, "hildon")
INSTALLATION_PATH="/opt/modrana"
ICON_CATEGORY="apps"
ICON_SIZES=[80,64]
BUGTRACKER_URL = "http://talk.maemo.org/showthread.php?t=58861"
PROJECT_URL = "http://www.modrana.org"
## load current changelog from the current_changelog file,
## add a header to it & append the complete changelog
time_stamp = time.strftime("%a %b %d %Y", time.gmtime())
change_header = '* %s %s <%s> - %s\n' % (
  time_stamp, MAINTAINER, MAINTAINER_EMAIL, VERSION
)
## create combined changes file
CURRENT_CHANGES = change_header
CURRENT_CHANGES += read("current_changelog").strip()

CHANGES = CURRENT_CHANGES
CHANGES += "\n"
CHANGES += read("changes").strip()

## get the complete Debian changelog (without entry for this build)
DEBIAN_COMPLETE_CHANGELOG = read('debian_changelog').strip()

if TARGET == "sdist_harmattan":
  INPUT_DESKTOP_FILE="harmattan/%s.desktop" % APP_NAME
elif TARGET == "sdist_fremantle":
  INPUT_DESKTOP_FILE="fremantle/%s.desktop" % APP_NAME
else:
  INPUT_DESKTOP_FILE="%s.desktop" % APP_NAME

print "%s SETUP.PY RUNNING" % PRETTY_APP_NAME


def is_package(path):
  return (
    os.path.isdir(path) and
    os.path.isfile(os.path.join(path, '__init__.py'))
  )

def find_packages(path, base="", includeRoot=False):
  """ Find all packages in path """
  if includeRoot:
    assert not base, "Base not supported with includeRoot: %r" % base
    rootPath, module_name = os.path.split(path)
    yield module_name
    base = module_name
  for item in os.listdir(path):
    dir = os.path.join(path, item)
    if is_package( dir ):
      if base:
        module_name = "%(base)s.%(item)s" % vars()
      else:
        module_name = item
      yield module_name
      for name in find_packages(dir, module_name):
        yield name

## list all files belonging to the application
listOfAllPaths = []
for (dirpath, dirnames, filenames) in os.walk('src'):
  for filename in filenames:
    listOfAllPaths.append(os.sep.join([dirpath, filename]))



## drop the root folder path for the second item in the tuple

## NOTE: this might not be fully OS agnostic
## How it works
## * the x is substituted for one item in the list
## * we split the path using the path separator to a list of strings
## * then we drop the first string from the list
## * using * ve "unroll" the list and supply it as a list of arguments to os.path.join
## * os.path.join should reconstruct the path back together including the new path root folder
## * os.path.dirname drops the filenames (or else we would get for example /opt/mieru/mieru.py/mieru.py
dataFiles = map( lambda x: (os.path.dirname( os.path.join(INSTALLATION_PATH, *x.split(os.path.sep)[1:]) ), [x] ), listOfAllPaths ) 

#dataFiles.extend(
#            [('/usr/share/applications',['mieru.desktop']),
#             ('/usr/share/icons/hicolor/80x80/apps', ['80x80/mieru.png']),
#             ('/usr/bin', ['mieru'])]
#                )

## add desktop file

if TARGET == "sdist_fremantle":
  dataFiles.extend([ (FREMANTLE_DESKTOP_FILE_PATH, [INPUT_DESKTOP_FILE]) ])
else:
  dataFiles.extend([ (DESKTOP_FILE_PATH, [INPUT_DESKTOP_FILE]) ])

## add icons
dataFiles.extend( [ (
                    "/usr/share/icons/hicolor/%sx%s/%s" % (size, size, ICON_CATEGORY),
                    ["icons/%sx%s/%s.png" % (size, size, APP_NAME)]
                    ) for size in ICON_SIZES ] )

## on Fremantle, add startup script to /usr/bin
if TARGET == "sdist_fremantle":
  dataFiles.extend( [ ("/usr/bin", ["fremantle/modrana"]) ] )
  dataFiles.extend( [ ("/usr/bin", ["fremantle/modrana-gtk"]) ] )
  dataFiles.extend( [ ("/usr/bin", ["fremantle/modrana-qml"]) ] )
  # add modRana-qml desktop file and icon
  dataFiles.extend([ (FREMANTLE_DESKTOP_FILE_PATH, ["fremantle/modrana-qml.desktop"]) ])
  dataFiles.extend([ ("/usr/share/icons/hicolor/64x64/apps", ["fremantle/modrana-qml.png"]) ])

setup(
  name=APP_NAME,
  version=VERSION,
  description="ModRana is a flexible GPS navigation system.",
  long_description=read('longdesc'),
  author=AUTHOR,
  author_email=AUTHOR_EMAIL,
  maintainer=MAINTAINER,
  maintainer_email=MAINTAINER_EMAIL,
  url=PROJECT_URL,
  license="GNU GPLv3",
  data_files=dataFiles,
  requires=[
    "PySide",
  ],
  cmdclass={
    'sdist_ubuntu': sdist_maemo,
    'sdist_diablo': sdist_maemo,
    'sdist_fremantle': sdist_maemo,
    'sdist_harmattan': sdist_maemo,
  },
  options={
    "sdist_ubuntu": {
      "debian_package": APP_NAME,
      "section": "navigation",
      "copyright": "gpl",
      "changelog": CHANGES,
      "buildversion": str(BUILD),
      "depends": "python, python-pyside.qtcore, python-pyside.qtgui, python-simplejson, python-gtk2",
      "architecture": "any",
    },
#		"sdist_diablo": {
#			"debian_package": APP_NAME,
#			"Maemo_Display_Name": PRETTY_APP_NAME,
#			#"Maemo_Upgrade_Description": CHANGES,
#			"Maemo_Bugtracker": BUGTRACKER_URL,
#			"Maemo_Icon_26": "data/icons/26/%s.png" % APP_NAME,
#			"section": "user/science",
#			"copyright": "gpl",
#			"changelog": CHANGES,
#			"buildversion": str(BUILD),
#			"depends": "python2.5, python2.5-qt4-core, python2.5-qt4-gui, python-xdg, python-simplejson",
#			"architecture": "any",
#		},
    "sdist_fremantle": {
      "debian_package": APP_NAME,
      "Maemo_Display_Name": PRETTY_APP_NAME,
      #"Maemo_Upgrade_Description": CHANGES,
      "Maemo_Bugtracker": BUGTRACKER_URL,
      "Maemo_Icon_26": "icons/64x64/%s.png" % APP_NAME,
      "section": "user/navigation",
      "copyright": "gpl",
      "changelog": CURRENT_CHANGES,
      "buildversion": str(BUILD),
      #"depends": "python2.5, python2.5-qt4-core, python2.5-qt4-gui, python2.5-qt4-maemo5, python-xdg, python-simplejson",
      "depends": "python-qtmobility12, python-pyside.qtgui, python-pyside.qtdeclarative, qt-components-10, espeak, python-dbus, python-protobuf, python-location, python-osso, python-conic, python-hildon, python",
      "architecture": "any",
      "postinst" : """#!/bin/sh
#DEBHELPER#

echo "removing old *.pyc files"
rm `find %s -name '*.pyc'`

echo "generating *.pyc files"
# generate *.pyc files to speed up startup
# also, after changing the permissions user ran python can't create them
python -m compileall %s

exit 0
""" % (INSTALLATION_PATH,INSTALLATION_PATH) ,
    },
    "sdist_harmattan": { # also serves for Nemo at the moment
      "debian_package": APP_NAME,
      "Maemo_Display_Name": PRETTY_APP_NAME,
      "Maemo_Upgrade_Description": CHANGES,
      "Maemo_Bugtracker": BUGTRACKER_URL,
      "Maemo_Icon_26": "icons/64x64/%s.png" % APP_NAME,
      "MeeGo_Desktop_Entry_Filename": APP_NAME,
      #"MeeGo_Desktop_Entry": "",
      "section": "user/navigation",
      "copyright": "gpl",
      "changelog": CURRENT_CHANGES,
      "buildversion": str(BUILD),
      "depends": "python-pyside.qtgui, python-pyside.qtdeclarative, python-qtmobility",
      "build_depends" : "debhelper (>= 5), python-support, aegis-builder",
      "architecture": "any",
      "aegis_manifest" : "harmattan/%s.aegis" % APP_NAME,
      "debian_complete_changelog" : DEBIAN_COMPLETE_CHANGELOG,
      "postinst" : """#!/bin/sh
#DEBHELPER#
echo "removing old *.pyc files"
rm `find %s -name '*.pyc'`

echo "generating *.pyc files"
# generate *.pyc files to speed up startup
# also, after changing the permissions user ran python can't create them
python -m compileall -f %s

exit 0
""" % (INSTALLATION_PATH,INSTALLATION_PATH),
    },
    "bdist_rpm": {
      "requires": "REPLACEME",
      "icon": "data/icons/64/%s.png" % APP_NAME,
      "group": "REPLACEME",
    },
  },
)


## finishing tasks

## save combined changes file if version changed
## (to save combined changes if the version doesn't
## change, just delete the "last_version" file)
last_version = read("last_version").strip("\n")
if VERSION != last_version:
  with open('changes','w') as f:
    f.write(CHANGES)

## record last build version
with open('last_version','w') as f:
  f.write(VERSION)