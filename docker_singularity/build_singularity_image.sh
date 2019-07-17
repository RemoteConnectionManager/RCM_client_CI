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
export BUILD_ROOT_PATH="$( dirname "$CURR_PATH" )" 
export BUILD_RCM_ARTIFACTS_PATH="$BUILD_ROOT_PATH/artifacts" 
###############   source specific VM setup ###########

export BUILD_USER=centos
export BUILD_HOST=192.168.0.80
export BUILD_SSH_COMMAND="ssh $BUILD_USER@${BUILD_HOST}"
export BUILD_SCP_COMMAND="scp"
export SINGULARITY_PATH="/home/centos/spack/singularity_view/bin/singularity"
export BUILD_DOCKER_IMAGE_NAME=$1
########################################################

echo "BUILD_ROOT_PATH-->$BUILD_ROOT_PATH<--"
echo "BUILD_RCM_ARTIFACTS_PATH-->$BUILD_RCM_ARTIFACTS_PATH<--"

############# system inspection #################################
inspect=$(${BUILD_SSH_COMMAND} "hostname; python -c 'import sys; print(sys.platform)'")
echo "inspect: $inspect"

############# environment #################################
#environment=$(${BUILD_SSH_COMMAND} "env")
#echo "environment: $environment"

##############   inspect VM environment ##############
version=$(${BUILD_SSH_COMMAND} "docker --version"  2>&1)
echo "SYSTEM Docker $version"

version=$(${BUILD_SSH_COMMAND} "${SINGULARITY_PATH} --version"  2>&1)
echo "CUSTOM Singularity $version"


echo "############ unconditionally clean sandbox folder from VM"
${BUILD_SSH_COMMAND} "if [ ! -f deploy ]; then rm -fr deploy; mkdir -p deploy/docker_projects; fi"

echo "############ unconditionally copy RCM folder to VM"
export COPY_DATA_COMMAND="${BUILD_SCP_COMMAND} -r ${CURR_PATH}/docker_projects/${BUILD_DOCKER_IMAGE_NAME} $BUILD_USER@${BUILD_HOST}:deploy/docker_projects"
echo "executing:::>${COPY_DATA_COMMAND}<:::"
${COPY_DATA_COMMAND}
export TARGET_DOCKER_SOURCE_FOLDER=$(${BUILD_SSH_COMMAND} "cd \$HOME/deploy/docker_projects/${BUILD_DOCKER_IMAGE_NAME}; pwd")
ls=$(${BUILD_SSH_COMMAND} "ls ${TARGET_DOCKER_SOURCE_FOLDER}")
echo "list of docker folder ${TARGET_DOCKER_SOURCE_FOLDER}  content ::>$ls<::"

echo "build Docker image ${BUILD_DOCKER_IMAGE_NAME}"
${BUILD_SSH_COMMAND} "sudo docker build -t ${BUILD_DOCKER_IMAGE_NAME}:base ${TARGET_DOCKER_SOURCE_FOLDER}"

ls=$(${BUILD_SSH_COMMAND} "ls ${TARGET_DOCKER_SOURCE_FOLDER}")
echo "list of docker folder ${TARGET_DOCKER_SOURCE_FOLDER}  content ::>$ls<::"

images=$(${BUILD_SSH_COMMAND} "sudo docker images")
echo "locally available images $images"

echo "########### build singularity image out of local docker cache"
remote_command="sudo ${SINGULARITY_PATH} build deploy/docker_projects/${BUILD_DOCKER_IMAGE_NAME}.sif docker-daemon://${BUILD_DOCKER_IMAGE_NAME}:base"
echo "remotely executing ::>${remote_command}<::"
${BUILD_SSH_COMMAND} ${remote_command}

################## copy artifacts from vm #######
${BUILD_SCP_COMMAND} -r $BUILD_USER@${BUILD_HOST}:deploy/docker_projects/${BUILD_DOCKER_IMAGE_NAME}.sif $BUILD_RCM_ARTIFACTS_PATH

