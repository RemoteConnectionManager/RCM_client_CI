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


###############   source specific VM setup ###########
export BUILD_HOST_PORT=""
source $CURR_PATH/$1/setup.sh
if [ "x${BUILD_HOST_PORT}" != "x" ]
then
    export BUILD_SSH_COMMAND="ssh $BUILD_USER@${BUILD_HOST} -p ${BUILD_HOST_PORT}"
    export BUILD_SCP_COMMAND="scp -P ${BUILD_HOST_PORT}"
else
    export BUILD_SSH_COMMAND="ssh $BUILD_USER@${BUILD_HOST}"
    export BUILD_SCP_COMMAND="scp" 
fi
########################################################
echo "BUILD_ROOT_PATH-->$BUILD_ROOT_PATH<--"
echo "BUILD_RCM_SOURCE_PATH-->$BUILD_RCM_SOURCE_PATH<--"
echo "BUILD_RCM_RELEASE-->$BUILD_RCM_RELEASE<--"
echo "BUILD_RCM_EXTERNAL_PATH-->$BUILD_RCM_EXTERNAL_PATH<--"
echo "BUILD_RCM_ARTIFACTS_PATH-->$BUILD_RCM_ARTIFACTS_PATH<--"

############# system inspection #################################
inspect=$(${BUILD_SSH_COMMAND} "hostname; python -c 'import sys; print(sys.platform)'")
echo "inspect: $inspect"

############# environment #################################
environment=$(${BUILD_SSH_COMMAND} "env")
echo "environment: $environment"

############# setup #################################
${BUILD_SSH_COMMAND} ${BUILD_SUDO_SETUP}

##############   inspect VM environment ##############
version=$(${BUILD_SSH_COMMAND} "python --version"  2>&1)
echo "system python version $version"

#pip not needed#version=$(ssh $BUILD_USER@${BUILD_HOST} "pip --version")
#pip not needed#echo "pip version $version"

################### setup virtualenv ###############
#uncomment#echo "unconditionally install virualenv"
#uncomment#ssh $BUILD_USER@${BUILD_HOST} "pip3 install virtualenv"

${BUILD_SSH_COMMAND} "if [ ! -f py3env/bin/activate ]; then ${BUILD_VIRTUALENV_COMMAND} py3env; fi"

##############   inspect virtualenv environment ##############
version=$(${BUILD_SSH_COMMAND} "source py3env/bin/activate && python --version"  2>&1)
echo "virtualenv python version $version"

echo "############ test paramiko import in virtualenv #####"
${BUILD_SSH_COMMAND} "source py3env/bin/activate && python -c \"exec(\\\"try: import paramiko\\\nexcept:\\\\n print( 'missing paramiko')\\\")\""

echo "############ unconditionally clean sandbox folder from VM"
${BUILD_SSH_COMMAND} "if [ ! -f deploy ]; then rm -fr deploy; mkdir deploy; fi"

echo "############ unconditionally copy RCM folder to VM"
echo "executing:::>${BUILD_SCP_COMMAND} -r ${BUILD_HOST_PORT} $BUILD_RCM_SOURCE_PATH $BUILD_USER@${BUILD_HOST}:deploy <:::"
${BUILD_SCP_COMMAND} -r ${BUILD_HOST_PORT} $BUILD_RCM_SOURCE_PATH $BUILD_USER@${BUILD_HOST}:deploy 

echo "install RCM requirements"
${BUILD_SSH_COMMAND} "source py3env/bin/activate && which pip3 && pip3 install -r deploy/RCM/rcm/client/requirements.txt && python -c \"exec(\\\"try: import paramiko\\\nexcept:\\\\n print( 'missing paramiko')\\\")\""

echo "copy external bundle"
if [ "x${BUILD_EXT_PATH}" != "x" ]
then
    ${BUILD_SCP_COMMAND} -r ${BUILD_HOST_PORT} $BUILD_RCM_EXTERNAL_PATH/$BUILD_EXT_PATH $BUILD_USER@${BUILD_HOST}:deploy/RCM/rcm/client/external/turbovnc 
fi

################## build release with pyinstaller #######
echo "building  both onedir nd onefile at same time"
build=$(${BUILD_SSH_COMMAND} "source py3env/bin/activate && cd deploy && pyinstaller RCM/rcm/client/rcm_client_qt.spec ${BUILD_RCM_RELEASE} ${BUILD_PLATFORM}")
echo "build result -->$build<--"

################## copy artifacts from vm #######
mkdir -p $BUILD_RCM_ARTIFACTS_PATH/$BUILD_PLATFORM
${BUILD_SCP_COMMAND} -r ${BUILD_HOST_PORT} $BUILD_USER@${BUILD_HOST}:deploy/dist/* $BUILD_RCM_ARTIFACTS_PATH

