#!/bin/bash

# Android packaging script
# TODO: merge this with the main script

PROJECT_FOLDER="modrana/android/android-project"
VERSION_STRING=`cat modrana/version`
TOPLEVEL=`pwd`
INPUT_APK="modrana-debug.apk"
OUTPUT_FOLDER="archive/android"

#echo "* updating from Git"
#cd modrana-git
#git pull
#cd $TOPLEVEL

echo "* rsyncing and filtering"
rsync -avzsh --delete --delete-excluded --progress modrana-git/ ${PROJECT_FOLDER}/app/modrana/  --exclude-from 'exclude-list.txt'

echo "* byte compiling"
python -m compileall -f ${PROJECT_FOLDER}/app/modrana -q

echo "* removing .py files"
find ${PROJECT_FOLDER}/app/modrana -type f -name "*.py" -exec rm -f {} \;

echo "* updating version file"
cp modrana/version ${PROJECT_FOLDER}/app/modrana/version.txt

echo "* making Android package"
cd ${PROJECT_FOLDER}
pydroid deploy complete
cd $TOPLEVEL

echo "* copying modRana package to archive"
cp ${PROJECT_FOLDER}/android/bin/${INPUT_APK} ${OUTPUT_FOLDER}/modrana_${VERSION_STRING}.apk
cp ${PROJECT_FOLDER}/android/bin/${INPUT_APK} ${OUTPUT_FOLDER}/modrana_latest.apk
echo ${OUTPUT_FOLDER}/modrana_${VERSION_STRING}.apk
echo ${OUTPUT_FOLDER}/modrana_latest.apk

echo "* Android packaging done"
