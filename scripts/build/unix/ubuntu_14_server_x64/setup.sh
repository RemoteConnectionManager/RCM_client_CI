#!/bin/bash

export BUILD_USER=ubuntu
export BUILD_HOST=192.168.0.79
export BUILD_PLATFORM=ubuntu14/64bit
export BUILD_EXT_PATH=turbovnc_bundle/linux/64bit
export BUILD_SUDO_SETUP="sudo apt-get update && sudo apt-get install -y python-pip python-dev build-essential  python3-pip python3.4-venv curl libdbus-1-3 libexpat1 libfontconfig1 libfreetype6 libgl1-mesa-glx libglib2.0-0 libx11-6 libx11-xcb1 software-properties-common pkg-config xvfb libffi-dev libssl-dev libglu1-mesa-dev libxrender1 libxkbcommon-x11-0"
export BUILD_VIRTUALENV_COMMAND="python3 -m venv"
export BUILD_VIRTUALENV_REQUIREMENTS="echo ##########skipping-requirements#######"
