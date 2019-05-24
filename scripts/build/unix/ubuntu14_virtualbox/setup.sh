#!/bin/bash
# this need reverse tunnel active: issue
# ssh -N -R 22001:localhost:22 ubuntu@130.186.13.241
# so on jienkins can issue:
# ssh ${BUILD_USER}@localhost -p ${BUILD_HOST_PORT}
export BUILD_USER=osboxes
export BUILD_HOST=localhost
export BUILD_HOST_PORT="22001"
export BUILD_PLATFORM=darwin/64bit
export BUILD_EXT_PATH=""
export BUILD_SUDO_SETUP="echo NO_MACOS_INSTALL"
export BUILD_VIRTUALENV_COMMAND="python3.6 -m venv"
