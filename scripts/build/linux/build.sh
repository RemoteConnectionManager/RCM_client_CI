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
export BUILD_RCM_RELEASE=$(cd $BUILD_RCM_SOURCE_PATH; git describe)
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

############# setup #################################
ssh $BUILD_USER@${BUILD_HOST} "sudo apt-get update && sudo apt-get install -y python-pip python-dev build-essential virtualenv"

##############   inspect VM environment ##############
version=$(ssh $BUILD_USER@${BUILD_HOST} "python --version")
echo "python version $version"

version=$(ssh $BUILD_USER@${BUILD_HOST} "pip --version")
echo "pip version $version"

################### setup virtualenv ###############
#uncomment#echo "unconditionally install virualenv"
#uncomment#ssh $BUILD_USER@${BUILD_HOST} "pip3 install virtualenv"

version=$(ssh $BUILD_USER@${BUILD_HOST} "virtualenv --version")
echo "virtualenv version $version"

ssh $BUILD_USER@${BUILD_HOST} "if [ ! -f py3env/bin/activate ]; then virtualenv -p python3 py3env; fi"

echo "############ test paramiko import in virtualenv #####"
ssh $BUILD_USER@${BUILD_HOST} "source py3env/bin/activate && python -c \"exec(\\\"try: import paramiko\\\nexcept:\\\\n print( 'missing paramiko')\\\")\""

echo "############ unconditionally clean sandbox folder from VM"
ssh $BUILD_USER@${BUILD_HOST} "if [ ! -f deploy ]; then rm -fr deploy; mkdir deploy; fi"

echo "############ unconditionally copy RCM folder to VM"
scp -r $BUILD_RCM_SOURCE_PATH $BUILD_USER@${BUILD_HOST}:deploy 

echo "install RCM requirements"
ssh $BUILD_USER@${BUILD_HOST} "source py3env/bin/activate && which pip3 && pip3 install -r deploy/RCM/rcm/client/requirements.txt && python -c \"exec(\\\"try: import paramiko\\\nexcept:\\\\n print( 'missing paramiko')\\\")\""

echo "copy external bundle"
scp -r $BUILD_RCM_EXTERNAL_PATH/$BUILD_EXT_PATH $BUILD_USER@${BUILD_HOST}:deploy/RCM/rcm/client/external/turbovnc 

################## build release with pyinstaller #######
echo "building  both onedir nd onefile at same time"
build=$(ssh $BUILD_USER@${BUILD_HOST} "source py3env/bin/activate && cd deploy && pyinstaller RCM/rcm/client/rcm_client_qt.spec")
echo "build result -->$build<--"

################## copy artifacts from vm #######
mkdir -p $BUILD_RCM_ARTIFACTS_PATH/$BUILD_PLATFORM
scp -r $BUILD_USER@${BUILD_HOST}:deploy/dist $BUILD_RCM_ARTIFACTS_PATH/$BUILD_PLATFORM/$BUILD_RCM_RELEASE

