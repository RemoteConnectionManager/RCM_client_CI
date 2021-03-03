# RCM_client_CI

### The Remote Connection Manager continuos integration  repository

This repo is using both git submodule as well as git lfs ( large file support )

For git lfs, git version should be >= 1.8.2

On ubuntu, for example:



```sh
git --version
# to install git-lfs
curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash
sudo apt-get install git-lfs
# register git-lfs plugin into git
git lfs install

```

```sh
git lfs --help
```
if lfs plugin is not present, instruction in 

* [Wiki git lfs hints](https://github.com/RemoteConnectionManager/RCM_client_CI/wiki/git-lfs)

```sh
git clone -b dev_new --recursive https://github.com/RemoteConnectionManager/RCM_client_CI.git 
cd RCM_client_CI
```

If you want to update to the latests commit also the submodule, do

```sh
cd RCM_client_CI
git submodule update --recursive --remote
```

In order to setup a developmemt environment on linux, you need python3 and virtualenv.
look at client instructions:
* [RCM client README](https://github.com/RemoteConnectionManager/RCM/tree/refactoring/rcm/client)

or you can use a setup script that is setting up needed environment and alias
try to find the best matching scripts for your current client architecture, like

```sh
source scripts/dev_setup.sh
RCM
```
The first time, the script should create a virtual environment, install RCM requirments and activate the environment, then yu shgould be able to execute the script that start the GUI interface.
In case of error during requirements install, try to fix the script, remo the produced virtual env and try again
