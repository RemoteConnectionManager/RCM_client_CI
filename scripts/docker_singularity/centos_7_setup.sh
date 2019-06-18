#!/bin/bash
#
# installing docker CE on centos
# from: https://docs.docker.com/install/linux/docker-ce/centos/
# 
sudo yum check-update; echo returned status $?
sudo yum remove docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-engine
sudo yum install -y yum-utils   device-mapper-persistent-data   lvm2
sudo yum-config-manager     --add-repo     https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install docker-ce docker-ce-cli containerd.io
docker --version
sudo systemctl start docker
sudo docker run hello-world

# Install development environment for running spack
#
sudo yum install -y git

# equivalent of build_essentials
# from: https://unix.stackexchange.com/questions/1338/what-is-the-fedora-equivalent-of-the-debian-build-essential-package/259039
# added also patch and bizip2 that are possibly needed when spack install some packages
#
sudo yum install -y   make automake gcc gcc-c++ kernel-devel patch bzip2
