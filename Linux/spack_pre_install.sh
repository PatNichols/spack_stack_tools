!/usr/local/bin/bash

if [[ $# -eq 0 ]] ; then
    echo 'you need to supply and env name'
    return 1
fi

source $PWD/setup.sh

export ENV=$PWD/envs/$1

echo "spack stack create env --name ${1} --template skylab-dev --site linux.default"

spack stack create env --name $1 --template skylab-dev --site macos.default

spack env activate $ENV

export SPACK_SYSTEM_CONFIG_PATH=$ENV/site

spack external find --scope system
spack external find --scope system perl
spack external find --scope system python
spack external find --scope system wget

spack external find curl

#Skip qt@5 for now
spack external find --scope system texlive

spack compiler find  --scope system

unset SPACK_SYSTEM_CONFIG_PATH

#Example for Ubuntu 20.04 following the above instructions
spack config add "packages:python:buildable:False"
spack config add "packages:openssl:buildable:False"
spack config add "packages:all:providers:mpi:[openmpi@1.4.5]"
spack config add "packages:all:compiler:[gcc@9.4.0]"