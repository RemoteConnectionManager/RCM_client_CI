FROM ubuntu:14.04
LABEL Description="Ubuntu trusty with git and other tools for spack"

# Dependencies of the Qt offline installer
RUN apt-get -y update && apt-get install -y \
    curl \
    git \
    patch \
    python \
    build-essential \
    software-properties-common # for add-apt-repository


