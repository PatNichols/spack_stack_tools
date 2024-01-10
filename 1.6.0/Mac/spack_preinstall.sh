#!/usr/local/bin/bash

if [[ $# -eq 0 ]] ; then
    echo 'you need to supply and env name'
    return 1
fi

source $PWD/setup.sh

export ENV=$PWD/envs/$1

export HOMEBREW_ROOT=/usr/local

echo "spack stack create env --name ${1} --template skylab-dev --site macos.default"

spack stack create env --name $1 --template skylab-dev --site macos.default

spack env activate $ENV

export SPACK_SYSTEM_CONFIG_PATH=$ENV/site

spack external find --scope system --exclude bison --exclude openssl
spack external find --scope system libiconv
spack external find --scope system perl
spack external find --scope system wget
spack external find --scope system mysql

PATH="$HOMEBREW_ROOT/opt/curl/bin:$PATH" \
     spack external find --scope system curl

PATH="$HOMEBREW_ROOT/opt/qt5/bin:$PATH" \
    spack external find --scope system qt

spack external find --scope system texlive

spack config --scope system add packages:pkg-config:buildable:false

spack compiler find  --scope system

unset SPACK_SYSTEM_CONFIG_PATH

spack config add "packages:all:providers:mpi:[openmpi@4.1.6]"
spack config add "packages:all:compiler:[apple-clang@14.0.0]"
