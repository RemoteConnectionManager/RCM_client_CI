#!/bin/bash

export BUILD_USER=centos
export BUILD_HOST=192.168.0.77
export BUILD_PLATFORM=centos7/64bit
export BUILD_EXT_PATH=turbovnc_bundle/linux/64bit
export BUILD_SUDO_SETUP="sudo yum check-update; echo returned status $? && sudo yum install -y python-devel python-virtualenv  make automake gcc gcc-c++ kernel-devel"
