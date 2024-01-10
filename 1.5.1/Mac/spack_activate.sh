#!/usr/local/bin/bash

if [[ $# -eq 0 ]] ; then
    echo 'you need to supply and env name'
    return 1
fi
export ENV=$PWD/envs/$1
source setup.sh
spack env activate $ENV
spack install
ml purge
ml use $ENV/install/modulefiles/Core
ml stack-apple-clang
ml stack-openmpi
ml stack-python
ml jedi-fv3-env
ml ewok-env