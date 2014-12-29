#!/bin/bash
# rsync the modRana source code from the Git repo folder
# to the Android packaging folder and remove files not needed
# on Android when at it

cd "$(dirname "$0")"

rm -rf modrana-android/modrana
mkdir modrana-android/modrana

rsync -ar --exclude-from exclude.txt ../../modrana-git/ modrana-android/modrana/
cd modrana-android
./qrcgen.py modrana "/"
cd ..
