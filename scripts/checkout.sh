#!/bin/bash
# thi is the equivalent of what jenkins does for checking out repo

git clone -b dev https://github.com/RemoteConnectionManager/RCM_client_CI $1
git submodule init
git submodule sync
git config --get remote.origin.url
git submodule init
git config -f .gitmodules --get-regexp ^submodule\.(.+)\.url
git config --get submodule.RCM.url
git config -f .gitmodules --get submodule.RCM.path
git submodule update --init --recursive --remote RCM

