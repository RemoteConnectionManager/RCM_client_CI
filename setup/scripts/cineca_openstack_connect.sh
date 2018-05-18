#!/bin/bash
#do not fix api.. otherwise image list    export OS_IMAGE_API_VERSION=2
export OS_AUTH_URL=http://130.186.17.67:5000/v3
export OS_PROJECT_NAME=CLOUD_RCM
export OS_IDENTITY_API_VERSION=3
export OS_DOMAIN_NAME=LDAP
export OS_VOLUME_API_VERSION=2
echo "Please enter your OpenStack Username: "
read -sr OS_USERNAME_INPUT
export OS_USERNAME=$OS_USERNAME_INPUT
echo "Please enter your OpenStack Password: "
read -sr OS_PASSWORD_INPUT
export OS_PASSWORD=$OS_PASSWORD_INPUT
export OS_REGION_NAME=RegionOne
if [ -z "$OS_REGION_NAME" ]; then unset OS_REGION_NAME; fi
export PS1='[\u@\h \W(${OS_USERNAME}_keystone)]\$ '

