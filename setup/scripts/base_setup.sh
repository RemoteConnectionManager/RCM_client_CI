#/bin/bash

#first update and upgrade
sudo apt-get update
sudo apt-get upgrade

#fix locale problems,
#perl: warning: Please check that your locale settings
# hints from
# https://ubuntuforums.org/showthread.php?t=1346581
# 
locale-gen it_IT.UTF-8
sudo locale-gen it_IT.UTF-8
sudo dpkg-reconfigure locales
sudo dpkg-reconfigure locales -y
sudo dpkg-reconfigure locales --terse

#   sudo apt-get update
#   sudo apt-get upgrade
#   sudo shutdown -h now

# add lvm for formatting external volume as extendable, see
# https://wiki.u-gov.it/confluence/display/SCAIUS/How+to+mount+a+volume+attached+to+a+virtual+machine

sudo apt-get install lvm2


# install virtualbox and vagrant
sudo apt-get install -y virtualbox vagrant
vagrant --version

# install python minimal
sudo apt-get install -y python-minimal
python --version
sudo apt-get install -y virtualenv python-pip
virtualenv --version
pip --version
#update vagrant

# add ssh keys to the machine
#   cd .ssh
#   vi authorized_keys 
