#!/bin/bash
# this need reverse tunnel active: issue
# ssh -N -R 22000:localhost:22 ubuntu@130.186.13.241
# so on jienkins can issue:
# ssh rcm@localhost -p 22000
export BUILD_USER=rcm
export BUILD_HOST=localhost
export BUILD_HOST_PORT="-p 22000"
export BUILD_PLATFORM=darwin/64bit
export BUILD_EXT_PATH=no_turbovnc_folder
export BUILD_SUDO_SETUP="echo NO_MACOS_INSTALL"
export BUILD_VIRTUALENV_COMMAND="virtualenv-3.6"
