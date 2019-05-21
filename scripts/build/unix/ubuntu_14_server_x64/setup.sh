#!/bin/bash

export BUILD_USER=ubuntu
export BUILD_HOST=192.168.0.79
export BUILD_PLATFORM=ubuntu14/64bit
export BUILD_EXT_PATH=turbovnc_bundle/linux/64bit
export BUILD_SUDO_SETUP="sudo apt-get update && sudo apt-get install -y python-pip python-dev build-essential  python3-pip python3.4-venv"
export BUILD_VIRTUALENV_COMMAND="python3 -m venv"
