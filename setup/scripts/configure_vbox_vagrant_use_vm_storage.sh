#!/bin/bash
if [ "x$VAGRANT_HOME" == "x" ]
then
  VAGRANT_HOME=/mnt/vmstorage/ubuntu/vagrant_vms
  echo "setting VAGRANT_HOME to $VAGRANT_HOME in $HOME/.bashrc"
  mkdir -p $VAGRANT_HOME
  echo "export VAGRANT_HOME=$VAGRANT_HOME" >> $HOME/.bashrc
fi

VIRTUALBOX_HOME=/mnt/vmstorage/ubuntu/vbox_vms
mkdir -p $VIRTUALBOX_HOME
vboxmanage setproperty machinefolder $VIRTUALBOX_HOME

