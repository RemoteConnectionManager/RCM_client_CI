#!/bin/bash

export BUILD_USER=arch
export BUILD_HOST=192.168.0.141
export BUILD_PLATFORM=arch/64bit
export BUILD_EXT_PATH=turbovnc_bundle/linux/64bit
export BUILD_SUDO_SETUP="sudo sudo pacman -Sy  && sudo pacman --noconfirm -S base-devel extra/python-pip extra/python-virtualenv"
export BUILD_VIRTUALENV_COMMAND="virtualenv -p python3"
