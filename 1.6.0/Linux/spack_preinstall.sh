#!/usr/bin/bash

if [[ $# -eq 0 ]] ; then
    echo 'you need to supply and env name'
    return 1
fi

source $PWD/setup.sh

export ENV=$PWD/envs/$1

echo "spack stack create env --name ${1} --template skylab-dev --site macos.default"

spack stack create env --name $1 --template skylab-dev --site macos.default

spack env activate $ENV

export SPACK_SYSTEM_CONFIG_PATH=$ENV/site

spack external find --scope system \
    --exclude bison --exclude cmake \
    --exclude curl --exclude openssl \
    --exclude openssh
spack external find --scope system wget
spack external find --scope system mysql
spack external find --scope system texlive

spack compiler find --scope system

spack config --scope system add packages:pkg-config:buildable:false

unset SPACK_SYSTEM_CONFIG_PATH

spack config add "packages:fontconfig:variants:+pic"
spack config add "packages:pixman:variants:+pic"
spack config add "packages:cairo:variants:+pic"
spack config add "packages:libffi:version:['3.3']"
spack config add "packages:flex:version:['2.6.4']"
spack config add "packages:all:providers:mpi:[openmpi@4.1.6]"
spack config add "packages:all:compiler:[gcc@14.0.0]"

