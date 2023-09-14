#!/usr/bin/bash

if [[ $# -eq 0 ]] ; then
    echo 'you need to supply and env name'
    return 1
fi
export ENV=$PWD/envs/$1

source setup.sh
spack env activate $ENV
#spack install
module  purge
module  use $ENV/install/modulefiles/Core
module load  stack-gcc
module load stack-openmpi
module load stack-python
module load jedi-fv3-env
module load ewok-env
