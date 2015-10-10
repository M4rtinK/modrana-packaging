#!/bin/bash
##
## ** Bento packaging script **
##

## source the configuration variables from
## config.sh

source config.sh

separator="."

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

function main_clean {
    ## make sure the src folder in main folder is empty
    echo "* cleaning source folder"
    rm -rf "${APP_NAME}/src/"
    mkdir "${APP_NAME}/src/"
    rm -rf ${APP_NAME}/dist/*
    rm -rf ${APP_NAME}/deb_dist/*
}

function copy_source {
    # copy source from GIT to the src folder
    echo "* copying source from git"
    cp -R ${APP_NAME}-git/* ${APP_NAME}/src
}

function clean_source {
    ## remove any *.pyc files and the .git folder
    echo "* cleaning source" # remove unneeded files
    find ${APP_NAME}/src -name "*.pyc" -exec rm -rf {} \; #remove pyc files
    rm -rf ${APP_NAME}/src/.git
    rm -rf ${APP_NAME}/src/nbproject
    echo "* source cleaning done"
}

function create_version_file {
    ## create the version file for internal use by modRana
    echo "* creating version file"
    touch ${APP_NAME}/src/version.txt
    echo $version_string > ${APP_NAME}/src/version.txt
}

function prepare_build {
    echo "* preparing build"
    main_clean
    copy_source
    clean_source
    create_version_file
}

function run_setup_py {
    ## run setup.py for the given target
    cd ${APP_NAME}
    python setup.py $1 &> ${LOG_FOLDER_NAME}/setup.py_target_${1}.log
    cd ..
}

function build_fremantle_package {
    ## build the Fremantle package using the maemo_sdist command
    echo "** building the Fremantle package"
    prepare_build
    
    ## run the Fremantle setup.py target
    run_setup_py sdist_fremantle

    ## archive the Fremantle package
    ## so that it can be used for the Autobuilder
    cp ${APP_NAME}/dist/*.* archive/fremantle
    ## also replace the current package, which is used
    ## by a SCP script for the Maemo autobuilder
    rm -f archive/fremantle/current/*.tar.gz
    rm -f archive/fremantle/current/*.changes
    rm -f archive/fremantle/current/*.dsc
    cp ${APP_NAME}/dist/*.* archive/fremantle/current
}

## create paclages
build_fremantle_package

echo "* packaging done"
