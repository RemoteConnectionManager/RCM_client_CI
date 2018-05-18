#!/bin/bash
if [ "x$1" != "x" ]
then
  ansible_venv=$1
else
  ansible_venv=$HOME/ansible_venv
fi
if ! [[ -f ${ansible_venv}/bin/activate ]]
then
  virtualenv $ansible_venv
  source ${ansible_venv}/bin/activate
  pip install ansible
  pip install pywinrm
  pip install shade
fi
source ${ansible_venv}/bin/activate
ansible_version=$(ansible --version | head -1 | cut -d' ' -f 2)
echo "current ansible version -->${ansible_version}"


