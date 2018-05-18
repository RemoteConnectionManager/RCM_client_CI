#!/bin/bash
set -e

#############   extract current path ##########


SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do
# resolve $SOURCE until the file is no longer a symli nk
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" 
# if $SOURCE was a relative symli nk, 
# we need to resolve it relative to the path where the symlink file was located
done
CURR_PATH="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
export BUILD_ROOT_PATH="$( dirname $( dirname $( dirname "$CURR_PATH" ) ) )" 
export BUILD_RCM_SOURCE_PATH="$BUILD_ROOT_PATH/RCM" 
export BUILD_RCM_EXTERNAL_PATH="$BUILD_ROOT_PATH/external" 
export BUILD_RCM_ARTIFACTS_PATH="$BUILD_ROOT_PATH/artifacts" 

########################################################
echo "BUILD_ROOT_PATH-->$BUILD_ROOT_PATH<--"
echo "BUILD_RCM_SOURCE_PATH-->$BUILD_RCM_SOURCE_PATH<--"
echo "BUILD_RCM_EXTERNAL_PATH-->$BUILD_RCM_EXTERNAL_PATH<--"
echo "BUILD_RCM_ARTIFACTS_PATH-->$BUILD_RCM_ARTIFACTS_PATH<--"
###############   source specific VM setup ###########
source $CURR_PATH/$1/setup.sh

##############   inspect VM environment ##############
version=$(ssh $BUILD_USER@${BUILD_HOST} "cmd /C python --version")
echo "python version $version"
version=$(ssh $BUILD_USER@${BUILD_HOST} "cmd /C pip --version")
echo "pip version $version"

################### setup virtualenv ###############
#uncomment#echo "unconditionally install virualenv"
#uncomment#ssh $BUILD_USER@${BUILD_HOST} "cmd /C pip install virtualenv "

version=$(ssh $BUILD_USER@${BUILD_HOST} "cmd /C virtualenv --version")
echo "virtualenv version $version"

ssh $BUILD_USER@${BUILD_HOST} "cmd /C IF NOT EXIST py3env\\\\Scripts\\\\activate \(virtualenv  py3env\) ELSE \(echo py3env\\\\Scripts\\\\activate exists\)"

echo "############ test paramiko import in virtualenv #####"
paramiko=$(ssh $BUILD_USER@${BUILD_HOST} "cmd /C py3env\\\\Scripts\\\\activate \&  python -c \"exec(\\\"try: import paramiko\\\nexcept:\\\\n print( 'missing paramiko')\\\")\"")
echo "virtualenv paramiko -->$paramiko<--"


echo "############ unconditionally clean sandbox folder from VM"
ssh $BUILD_USER@${BUILD_HOST} "cmd /C IF EXIST deploy \(rmdir deploy /s /q \) "
ssh $BUILD_USER@${BUILD_HOST} "cmd /C IF NOT EXIST deploy \(mkdir deploy \) ELSE \(echo deploy folder exists\)"

echo "############ unconditionally copy RCM folder to VM"
ssh $BUILD_USER@${BUILD_HOST} "cmd /C IF EXIST deploy\\\RCM \(rmdir deploy\\\RCM /s /q \) "
scp -r $BUILD_RCM_SOURCE_PATH $BUILD_USER@${BUILD_HOST}:deploy 

echo "install RCM requirements"
paramiko=$(ssh $BUILD_USER@${BUILD_HOST} "cmd /C py3env\\\\Scripts\\\\activate \& pip install -r deploy\\\\RCM\\\\rcm\\\\client\\\\requirements.txt \& python -c \"exec(\\\"try: import paramiko\\\nexcept:\\\\n print( 'missing paramiko')\\\")\"")
echo "virtualenv paramiko -->$paramiko<--"


#ssh $BUILD_USER@${BUILD_HOST} "cmd /C dir deploy"
echo "copy external bundle"
ssh $BUILD_USER@${BUILD_HOST} "cmd /C IF EXIST deploy\\\turbovnc \(rmdir deploy\\\turbovnc /s /q \) "
scp -r $BUILD_RCM_EXTERNAL_PATH/$BUILD_EXT_PATH $BUILD_USER@${BUILD_HOST}:deploy/RCM/rcm/client/external/turbovnc 

################## build release with pyinstaller #######
echo "building onedir "
build=$(ssh $BUILD_USER@${BUILD_HOST} "cmd /C py3env\\\\Scripts\\\\activate \& cd deploy \& mkdir onedir \& cd onedir \& pyinstaller ..\\\\RCM\\\\rcm\\\\client\\\\rcm_client_qt_onedir.spec")
echo "build result -->$build<--"

################## copy artifacts from vm #######
scp -r $BUILD_USER@${BUILD_HOST}:deploy/onedir/dist/rcm_client_qt $BUILD_RCM_ARTIFACTS_PATH/$BUILD_PLATFORM/rcm_client_qt_dir

echo "building onefile "
build=$(ssh $BUILD_USER@${BUILD_HOST} "cmd /C py3env\\\\Scripts\\\\activate \& cd deploy \& mkdir onefile \& cd onefile \& pyinstaller ..\\\\RCM\\\\rcm\\\\client\\\\rcm_client_qt_onefile.spec")
echo "build result -->$build<--"

################## copy artifacts from vm #######
scp  $BUILD_USER@${BUILD_HOST}:deploy/onefile/dist/rcm_client_qt $BUILD_RCM_ARTIFACTS_PATH/$BUILD_PLATFORM
