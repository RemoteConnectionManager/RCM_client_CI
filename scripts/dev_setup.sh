#!/bin/bash
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do
# resolve $SOURCE until the file is no longer a symli nk
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
# if $SOURCE was a relative symli nk, 
# we need to resolve it relative to the path where the symlink file was located
done
RCM_CI_ROOTPATH="$( cd -P "$( dirname "$( dirname "$SOURCE" )" )" && pwd )"
RCM_TURBOVNC_PREFIX=${RCM_CI_ROOTPATH}/external/turbovnc_bundle/linux/64bit
RCM_VIRTUALENV=${RCM_CI_ROOTPATH}/py3env
if [ ! -d "$RCM_VIRTUALENV" ]; then
  virtualenv -p python3 $RCM_VIRTUALENV
  source ${RCM_VIRTUALENV}/bin/activate
  pip3 install -r ${RCM_CI_ROOTPATH}/RCM/rcm/client/requirements.txt
else
  source ${RCM_VIRTUALENV}/bin/activate
fi

export PATH=${RCM_TURBOVNC_PREFIX}/bin:$PATH
export JAVA_HOME=${RCM_TURBOVNC_PREFIX}
export JDK_HOME=${RCM_TURBOVNC_PREFIX}
export JRE_HOME=${RCM_TURBOVNC_PREFIX}/jre
export CLASSPATH=${JAVA_HOME}/lib:${JRE_HOME}/lib
#export LD_LIBRARY_PATH=${RCM_TURBOVNC_PREFIX}/bin:$LD_LIBRARY_PATH

alias RCM='python ${RCM_CI_ROOTPATH}/RCM/rcm/client/rcm_client_qt.py'
