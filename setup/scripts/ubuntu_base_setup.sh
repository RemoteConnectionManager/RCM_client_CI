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

# add ssh keys to the machine
#   cd .ssh
#   vi authorized_keys 

