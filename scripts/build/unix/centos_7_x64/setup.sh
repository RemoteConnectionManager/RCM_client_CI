#!/bin/bash

export BUILD_USER=centos
export BUILD_HOST=192.168.0.106
export BUILD_PLATFORM=centos7/64bit
export BUILD_EXT_PATH=turbovnc_bundle/linux/64bit
export BUILD_SUDO_SETUP="sudo yum check-update; echo returned status $? && sudo yum install -y  epel-release python36 python36-virtualenv make automake gcc gcc-c++ kernel-devel"
export BUILD_VIRTUALENV_COMMAND="virtualenv-3.6"
