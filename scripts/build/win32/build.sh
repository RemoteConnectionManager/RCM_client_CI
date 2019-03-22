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
export BUILD_RCM_RELEASE=$(cd $BUILD_RCM_SOURCE_PATH; git describe --tags --long | python -c 'import sys; print(sys.stdin.readline().strip().split("/")[-1:][0])')
export BUILD_RCM_EXTERNAL_PATH="$BUILD_ROOT_PATH/external" 
export BUILD_RCM_ARTIFACTS_PATH="$BUILD_ROOT_PATH/artifacts" 

########################################################
echo "BUILD_ROOT_PATH-->$BUILD_ROOT_PATH<--"
echo "BUILD_RCM_SOURCE_PATH-->$BUILD_RCM_SOURCE_PATH<--"
echo "BUILD_RCM_RELEASE-->$BUILD_RCM_RELEASE<--"
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
echo "building  both onedir nd onefile at same time"
build=$(ssh $BUILD_USER@${BUILD_HOST} "cmd /C py3env\\\\Scripts\\\\activate \& cd deploy \& pyinstaller RCM\\\\rcm\\\\client\\\\rcm_client_qt.spec ${BUILD_RCM_RELEASE}")
echo "build result -->$build<--"

################## copy artifacts from vm #######
mkdir -p $BUILD_RCM_ARTIFACTS_PATH/$BUILD_PLATFORM
scp -r $BUILD_USER@${BUILD_HOST}:deploy/dist $BUILD_RCM_ARTIFACTS_PATH/$BUILD_PLATFORM/$BUILD_RCM_RELEASE

