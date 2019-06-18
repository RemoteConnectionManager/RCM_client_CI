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
###############   source specific VM setup ###########
source $CURR_PATH/$1/setup.sh

##############   inspect VM environment ##############
ssh $BUILD_USER@${BUILD_HOST} "cmd /C slmgr -rearm "
