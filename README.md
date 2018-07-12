# RCM_client_CI

### The Remote Connection Manager continuos integration  repository

This repo is using both git submodule as well as git lfs ( large file support )

chech your git version is recent ( > 2.13 )


```sh
git --version
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

```sh
virtualenv -p python3 py3env
source py3env/bin/activate
pip3 install -r RCM_client_CI/RCM/rcm/client/requirements.txt
```

