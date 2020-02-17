#!/bin/bash

export BUILD_USER=vagrant
export BUILD_HOST=192.168.0.84
export BUILD_PLATFORM=ubuntu16/64bit
export BUILD_EXT_PATH=turbovnc_bundle/linux/64bit
export BUILD_SUDO_SETUP="sudo apt-get update && sudo apt-get install -y python-pip python-dev build-essential virtualenv"
export BUILD_VIRTUALENV_COMMAND="virtualenv -p python3"
