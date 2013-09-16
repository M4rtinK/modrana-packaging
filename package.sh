#!/bin/bash
##
## ** Bento packaging script **
##

## source the configuration variables from
## config.sh

source config.sh

separator="."
# for now, obs_package_path == Nemo OBS path
# (due to MeeGo COBS shutdown)
nemo_obs_package_path="home:MartinK:${APP_NAME}/${APP_NAME}/"

## generate version string
short_version_string=${APP_VERSION_MAIN}${separator}${APP_VERSION_MINOR}${separator}${APP_VERSION_BUILD}
echo ${short_version_string} > ${APP_NAME}/version

## update changelog file
#rm -f  ${APP_NAME}/${APP_NAME}.changelog
echo "${APP_CHANGELOG}" >  ${APP_NAME}/current_changelog

## start from current directory
start_path=`pwd`

echo $start_path

echo "** packaging "${APP_NAME}" version: "${short_version_string}

## pull changes from git
echo "* updating from git"
cd  ${APP_NAME}-git
git pull

## get git tag and version info
tag=`git describe --always --tag`
version_string=V${short_version_string}" git:"${tag}

## return back to the main folder
cd ..

## make sure the src folder in main folder is empty
echo "* cleaning source folder"
rm -rf "${APP_NAME}/src/"
mkdir "${APP_NAME}/src/"

# copy source from GIT to the src folder
echo "* copying source from git"
cp -R ${APP_NAME}-git/* ${APP_NAME}/src

## change directory to the packaging folder
cd ${APP_NAME}

## remove any *.pyc files and the .git folder
echo "* cleaning" # remove unneeded files
find src -name "*.pyc" -exec rm -rf {} \; #remove pyc files
rm -rf src/.git
rm -rf src/nbproject
echo "* cleaning done"

## create the version file for internal use by Mieru
echo "* creating version file"
touch src/version.txt
echo $version_string > src/version.txt


## build the Harmattan package using the maemo_sdist command

echo "* building Harmattan package"

## cleanup
rm -rf dist/*
rm -rf deb_dist/*

python setup.py sdist_harmattan

## return back to the main folder
cd ${start_path}

## archive the Harmattan package
cp ${APP_NAME}/dist/*.* archive/harmattan
## also replace the current package
rm -f archive/harmattan/current/*.tar.gz
rm -f archive/harmattan/current/*.changes
rm -f archive/harmattan/current/*.dsc
cp ${APP_NAME}/dist/*.* archive/harmattan/current

## replace the OBS package by newer version
#rm -f ${obs_package_path}*.tar.gz
#rm -f ${obs_package_path}*.deb
#rm -f ${obs_package_path}*.changes
#rm -f ${obs_package_path}*.dsc
#cp ${APP_NAME}/dist/*.* ${obs_package_path}
#rm -f ${obs_package_path}*.spec


## build the nemo tarball & specfile

## Nemo cleanup
rm -rf ${APP_NAME}/dist/*
rm -rf ${APP_NAME}/deb_dist/*
rm -rf ${nemo_obs_package_path}/*.tar.gz
rm -rf ${nemo_obs_package_path}/*.spec
## run the setup.py
cd ${APP_NAME}
python setup.py sdist_nemo
cd ..
cp ${APP_NAME}/dist/*.tar.gz ${nemo_obs_package_path}
cp ${APP_NAME}/dist/*.spec ${nemo_obs_package_path}

## build the Fremantle package using the maemo_sdist command

echo "* building Fremantle package"

## change directory to the packaging folder
cd ${APP_NAME}

echo "* building"
rm -rf dist/*
python setup.py sdist_fremantle

## return back to main folder
cd ${start_path}

## archive the Fremantle package
## so that it can be used for the Autobuilder
cp ${APP_NAME}/dist/*.* archive/fremantle
## also replace the current package, which is used
## by a SCP script for the Maemo autobuilder
rm -f archive/fremantle/current/*.tar.gz
rm -f archive/fremantle/current/*.changes
rm -f archive/fremantle/current/*.dsc
cp ${APP_NAME}/dist/*.* archive/fremantle/current

## create a plain tarball
mkdir ${APP_NAME}/tmp_tarballing/
mv ${APP_NAME}/src/ ${APP_NAME}/tmp_tarballing/${APP_NAME}
cd ${APP_NAME}/tmp_tarballing/
tar czf ${APP_NAME}_${short_version_string}.tar.gz ${APP_NAME}
cd ../..
## archive the tarball
mv ${APP_NAME}/tmp_tarballing/${APP_NAME}_${short_version_string}.tar.gz archive/plain_tarballs/

## cleanup
rm -rf ${APP_NAME}/tmp_tarballing/
rm -rf ${APP_NAME}/src/

## replace the OBS package by newer version
#rm -f ${fremantle_obs_package_path}/*.tar.gz
#rm -f ${fremantle_obs_package_path}/*.deb
#rm -f ${fremantle_obs_package_path}/*.changes
#rm -f ${fremantle_obs_package_path}/*.dsc
#cp ${APP_NAME}/dist/*.* ${fremantle_obs_package_path}
#rm -f ${fremantle_obs_package_path}/*.spec

## wait for a key press so that the package can be checked
## before upload to OBS
echo "type h for Harmattan upload to OBS"
echo "f for Fremantle upload to OBS"
echo "nemo for Nemo upload to OBS"
echo "or a to upload all"
echo "and n or something else to exit"
read reply

## HARMATTAN ONLY ##

if [ "$reply" == "h" ];
then
  echo "* Harmattan: uploading to OBS"
  cd ${obs_package_path}
  osc ar
  osc commit -m "${APP_NAME} version ${short_version_string}"
  echo "* Harmattan OBS upload done"
else
  echo "* no Harmattan upload exiting"
fi


## FREMANTLE ONLY ##

if [ "$reply" == "f" ];
then
  echo "* Fremantle: uploading to OBS"
  cd ${fremantle_obs_package_path}
  osc ar
  osc commit -m "${APP_NAME} version ${short_version_string}"
  echo "* Fremantle OBS upload done"
else
  echo "* no Fremantle upload"
fi

## NEMO ONLY ##

if [ "$reply" == "nemo" ];
then
  echo "* Nemo: uploading to OBS"
  cd ${nemo_obs_package_path}
  osc ar
  osc commit -m "${APP_NAME} version ${short_version_string}"
  echo "* Nemo OBS upload done"
else
  echo "* no Nemo upload"
fi

## ALL ##

if [ "$reply" == "a" ];
then
  echo "* ALL: uploading to OBS"
  echo "OBS Harmattan upload"
  cd ${start_path}
  cd ${obs_package_path}
  osc ar
  osc commit -m "${APP_NAME} version ${short_version_string}"
  echo "* OBS Harmattan upload done"
  echo "OBS Fremantle upload"
  cd ${start_path}
  cd ${fremantle_obs_package_path}
  osc ar
  osc commit -m "${APP_NAME} version ${short_version_string}"
  echo "* Fremantle OBS upload done"
  echo "OBS Nemo upload"
  cd ${start_path}
  cd ${nemo_obs_package_path}
  osc ar
  osc commit -m "${APP_NAME} version ${short_version_string}"
  echo "* Nemo OBS upload done"
  echo "* combined OBS upload done"
else
  echo "* exiting"
fi

echo "* packaging done"
