#/bin/bash
#this is needed to use winrm
#https://stackoverflow.com/questions/35016414/vagrant-up-fails-with-cannot-load-winrm
#https://stackoverflow.com/questions/36811863/cant-install-vagrant-plugins-in-ubuntu/36991648#36991648
#https://groups.google.com/forum/#!topic/vagrant-up/mBYMUHm-YBI
#https://github.com/openebs/openebs/issues/32
#https://releases.hashicorp.com/vagrant/

if [ "x$1" != "x" ]
then
  vagrant_version=$1
else
  vagrant_version="2.1.1"
fi

current_vagrant_version=$(vagrant --version  | cut -d ' ' -f2)
if [ "x$current_vagrant_version" != "x$vagrant_version" ]
then
  vagrant_deb="vagrant_${vagrant_version}_x86_64.deb"
  vagrant_url="wget https://releases.hashicorp.com/vagrant/${vagrant_version}/${vagrant_deb}"
  cd /tmp
  rm ${vagrant_deb}
  wget $vagrant_url
  sudo apt-get remove -y vagrant
  rm -r $HOME/.vagrant.d
  ls $HOME/.vagrant.d
  sudo dpkg -i ${vagrant_deb}
else
  echo "Vagrant version already $vagrant_version"
fi
