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

spack external find --scope system

spack external find --not-buildable --scope system perl

# Don't use any external Python, let spack build it
#spack external find --not-buildable --scope system python

spack external find --not-buildable --scope system wget

spack external find --scope system boost

spack external find --not-buildable --scope system expat

PATH="$HOMEBREW_ROOT/opt/curl/bin:$PATH" \
     spack external find --not-buildable --scope system curl

PATH="$HOMEBREW_ROOT/opt/qt5/bin:$PATH" \
    spack external find --not-buildable --scope system qt

PATH="$HOMEBREW_ROOT/opt/mysql/bin:$PATH" \
     spack external find --not-buildable --scope system mysql

PATH="$HOMEBREW_ROOT/opt/libxml2/bin:$PATH" \
     spack external find --not-buildable --scope system libxml2

# Optional, only if planning to build jedi-tools environment with LaTeX support
# The texlive bin directory must have been added to PATH (see above)
spack external find --not-buildable --scope system texlive

#spack external find --scope sysem openmpi

spack compiler find  --scope system

unset SPACK_SYSTEM_CONFIG_PATH

spack config add "packages:all:providers:mpi:[openmpi@4.1.5]"

spack config add "packages:all:compiler:[apple-clang@14.0.0]"
