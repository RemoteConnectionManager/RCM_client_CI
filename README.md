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
mkdir <new_folder>
cd <new_folder>
git clone https://github.com/RemoteConnectionManager/RCM_client_CI.git
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
```sh
source scripts/dev_setup.sh
RCM
```

