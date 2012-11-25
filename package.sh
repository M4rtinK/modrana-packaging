#!/bin/bash

##
## ** modRana packaging script **
##

name=modrana
version='0'
minor='37'
build='28'

separator="."
obs_package_path="home:MartinK:${name}/${name}/"
fremantle_obs_package_path="home:MartinK:${name}:${name}-fremantle/${name}/"
nemo_obs_package_path="home:MartinK:${name}:${name}-nemo/${name}/"

## generate version string
short_version_string=${version}${separator}${minor}${separator}${build}
echo ${short_version_string} > ${name}/version


## add changelog on the lines after
## "changelog=$( cat <<EOF"
## and before
## "EOF"

changelog=$( cat <<EOF
- add meridian/parallel grid display support
  - can be enabled in options->Map->Grid
  - configurable grid color
EOF
)

## update changelog file
#rm -f  ${name}/${name}.changelog
echo "${changelog}" >  ${name}/current_changelog

## start from current directory
start_path=`pwd`

echo "** packaging "${name}" version: "${short_version_string}

## pull changes from git
echo "* updating from git"
cd  ${name}-git
git pull

## get git tag and version info
tag=`git describe --always --tag`
version_string=V${short_version_string}" git:"${tag}

## return back to the main folder
cd ..

## make sure the src folder in main folder is empty
echo "* cleaning source folder"
rm -rf "${name}/src/"
mkdir "${name}/src/"

# copy source from GIT to the src folder
echo "* copying source from git"
cp -R ${name}-git/* ${name}/src

## change directory to the packaging folder
cd ${name}

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

## archive the package Harmattan
#cp ${name}/dist/*.* archive/
## TODO: separate harmattan archive

## replace the OBS package by newer version
rm -rf ${obs_package_path}/${name}/*.tar.gz
rm -rf ${obs_package_path}/${name}/*.deb
rm -rf ${obs_package_path}/${name}/*.changes
rm -rf ${obs_package_path}/${name}/*.dsc
cp ${name}/dist/*.* ${obs_package_path}
rm -rf ${obs_package_path}/${name}/*.spec


## build the nemo tarball & specfile

## Nemo cleanup
rm -rf ${name}/dist/*
rm -rf ${name}/deb_dist/*
rm -rf ${nemo_obs_package_path}/*.tar.gz
rm -rf ${nemo_obs_package_path}/*.spec
## run the setup.py
cd ${name}
python setup.py sdist_nemo
cd ..
cp ${name}/dist/*.tar.gz ${nemo_obs_package_path}
cp ${name}/dist/*.spec ${nemo_obs_package_path}

## build the Fremantle package using the maemo_sdist command

echo "* building Fremantle package"

## change directory to the packaging folder
cd ${name}

echo "* building"
rm -rf dist/*
python setup.py sdist_fremantle

## return back to main folder
cd ${start_path}

## archive the Fremantle package
## so that it can be used for the Autobuilder
cp ${name}/dist/*.* archive/

## create a plain tarball
mkdir ${name}/tmp_tarballing/
mv ${name}/src/ ${name}/tmp_tarballing/${name}
cd ${name}/tmp_tarballing/
tar czf ${name}_${short_version_string}.tar.gz ${name}
cd ../..
## archive the tarball
mv ${name}/tmp_tarballing/${name}_${short_version_string}.tar.gz archive/plain_tarballs/

## cleanup
rm -rf ${name}/tmp_tarballing/
rm -rf ${name}/src/

## replace the OBS package by newer version
rm -rf ${fremantle_obs_package_path}/*.tar.gz
rm -rf ${fremantle_obs_package_path}/*.deb
rm -rf ${fremantle_obs_package_path}/*.changes
rm -rf ${fremantle_obs_package_path}/*.dsc
cp ${name}/dist/*.* ${fremantle_obs_package_path}
rm -rf ${fremantle_obs_package_path}/*.spec

## wait for a key press so that the package can be checked
## before upload to OBS
echo "type h for Harmattan upload to OBS"
echo "f for Fremantle upload to OBS"
echo "nemo for Nemo upload to OBS"
echo "or y to upload both"
echo "and n or something else to exit"
read reply

## HARMATTAN ONLY ##

if [ "$reply" == "h" ];
then
  echo "* Harmattan: uploading to OBS"
  cd ${obs_package_path}
  osc ar
  osc commit -m "${name} version ${short_version_string}"
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
  osc commit -m "${name} version ${short_version_string}"
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
  osc commit -m "${name} version ${short_version_string}"
  echo "* Nemo OBS upload done"
else
  echo "* no Nemo upload"
fi

## ALL ##

if [ "$reply" == "y" ];
then
  echo "* ALL: uploading to OBS"
  cd ${start_path}
  cd ${obs_package_path}
  osc ar
  osc commit -m "${name} version ${short_version_string}"
  echo "* OBS Harmattan upload done"
  cd ${start_path}
  cd ${fremantle_obs_package_path}
  osc ar
  osc commit -m "${name} version ${short_version_string}"
  echo "* Fremantle OBS upload done"
  cd ${start_path}
  cd ${nemo_obs_package_path}
  osc ar
  osc commit -m "${name} version ${short_version_string}"
  echo "* Nemo OBS upload done"
  echo "* combined OBS upload done"
else
  echo "* exiting"
fi

echo "* packaging done"
