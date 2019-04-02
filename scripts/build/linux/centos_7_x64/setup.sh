#!/bin/bash

export BUILD_USER=centos
export BUILD_HOST=192.168.0.77
export BUILD_PLATFORM=centos7/64bit
export BUILD_EXT_PATH=turbovnc_bundle/linux/64bit
export BUILD_SUDO_SETUP="sudo yum check-update  && sudo yum install -y python-pip python-dev build-essential virtualenv"
