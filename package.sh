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
sailfish_obs_package_path="home:MartinK:sailfish:${APP_NAME}/harbour-${APP_NAME}/"

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

function build_harmattan_package {
    ## build the Harmattan package using the maemo_sdist command
    echo "** building Harmattan package"
    prepare_build

    ## run the Harmattan setup.py file
    run_setup_py sdist_harmattan

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
}

function build_nemo_package {
    ## build the nemo tarball & specfile
    echo "** building the Nemo package"
    prepare_build

    ## Nemo cleanup
    rm -rf ${nemo_obs_package_path}/*.tar.gz
    rm -rf ${nemo_obs_package_path}/*.spec
    ## run the Nemo setup.py
    run_setup_py sdist_nemo

    cp ${APP_NAME}/dist/*.tar.gz ${nemo_obs_package_path}
    cp ${APP_NAME}/dist/*.spec ${nemo_obs_package_path}
}

function prepare_sailfish_source {
    ## remove stuff we don't need when installing the package
    ## from a package on Sailfish OS and mangle its structure
    ## so that sailfish-qml can launch it

    echo "* cleaning source for Sailfish"

    mv ${APP_NAME}/src ${APP_NAME}/src_full

    ## clean the source folder based on rsync exclude list in
    ## ${APP_name}/sailfish/exclude.txt
    rsync -ar --exclude-from  ${APP_NAME}/sailfish/exclude.txt ${APP_NAME}/src_full/ ${APP_NAME}/src 

    ## now we can remove the full folder
    rm -rf ${APP_NAME}/src_full

    echo "* mangling source for Sailfish"

    ## change Universal Component import to relative imports
    ## as the Sailfish QML launcher is too stupid to support
    ## adding custom import paths and using a C++ loader
    ## doesn't seem like a good idea for othervise
    ## pure Python/QML application

    local qt5_qml_path="${APP_NAME}/src/modules/gui_modules/gui_qt5/qml"
    local qt5_qml_path_relative=
    local UC_silica_path="${qt5_qml_path}/universal_components/silica/UC"
    local UC_silica_path_relative="../modules/gui_modules/gui_qt5/qml/universal_components/silica/UC"
  
    ## move the qml folder to future install folder top-level
    mv $qt5_qml_path ${APP_NAME}/src
    
    ## move the UC Silica module to the QML folder because #unline qmlscene, the 
    ## Sailfish QML launcher can't be bothered to support inclusing additional import paths
    mv ${APP_NAME}/src/qml/universal_components/silica/UC ${APP_NAME}/src/qml/UC
    rm -rf ${APP_NAME}/src/qml/universal_components/
    
    ## replace proper module import with directory-relative ones

    ## thanky you captan sailfish-qml !
    ## without you, we won't be able to learn such nice Bash commands :)
    function replace_import {
        patern=modrana/src/qml/modrana_components/
        if [[ $1 = $patern* ]]
        then
            sed -i 's/import UC 1\.0/import "\..\/UC"/g' $1
        else
            sed -i 's/import UC 1\.0/import "\.\/UC"/g' $1
        fi

    }

    export -f replace_import

    find ${APP_NAME}/src/qml -type f -exec bash -c 'replace_import "$0"' {} \;

    ## tell the main QML script the platform id so that we don't have to run
    ## platform detection
    sed -i 's/property string \_PLATFORM\_ID\_/property string \_PLATFORM\_ID\_ \: "jolla"/g' ${APP_NAME}/src/qml/main.qml

    ## also, the sailfish-qml launcher, in its infinite wisdom, sets PWD to /home/nemo.......
    ## so we have to account for this (why oh why we need to do such hacks...)    
    sed -i 's/property string \_PYTHON\_IMPORT\_PATH\_/property string \_PYTHON\_IMPORT\_PATH\_ \: "\/usr\/share\/harbour-modrana"/g' ${APP_NAME}/src/qml/main.qml

    ## furthermore the stupid Sailfish QML launcher needs the app structured like this:
    ## /usr/share/harbour-<app name>/qml/harbour-<app name>.qml
    ## so we need to rename the sensibly named main.qml to modrana.qml
    mv ${APP_NAME}/src/qml/main.qml ${APP_NAME}/src/qml/harbour-${APP_NAME}.qml

    ## also byte-compile all Python code
    echo "* byte-compiling Python code with Python 3.3"
    python3.3 -m compileall ${APP_NAME}/src &> ${APP_NAME}/build_logs/sailfish_python_compileall.log
}

function build_sailfish_package {
    ## build the Sailfish tarball & specfile
    echo "** building the Sailfish package"

    ## Sailfish cleanup
    rm -rf ${sailfish_obs_package_path}/*.tar.gz
    rm -rf ${sailfish_obs_package_path}/*.spec

    ## regenerate source folder that might got nuked
    ## by pther package generation, so clean it first
    prepare_build
    ## do Sailfish specific tweaks
    prepare_sailfish_source

    ## run the Sailfish setup.py
    run_setup_py sdist_sailfish

    echo "* checking Sailfish build results:"
    ls -lah ${APP_NAME}/dist/
    cp ${APP_NAME}/dist/*.tar.gz ${sailfish_obs_package_path}
    cp ${APP_NAME}/dist/*.spec ${sailfish_obs_package_path}
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

function make_tarball {
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
}

## create paclages
build_harmattan_package
build_nemo_package
build_sailfish_package
build_fremantle_package
make_tarball

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

## SAILFISH ONLY ##

if [ "$reply" == "sail" ];
then
  echo "* Sailfish: uploading to OBS"
  cd ${sailfish_obs_package_path}
  osc ar
  osc commit -m "${APP_NAME} version ${short_version_string}"
  echo "* Sailfish OBS upload done"
else
  echo "* no Sailfish upload"
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
