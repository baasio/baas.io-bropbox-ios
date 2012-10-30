#!/bin/sh

git --version
GIT_IS_AVAILABLE=$?
if [ $GIT_IS_AVAILABLE -eq 0 ]; then
    git submodule init
    git submodule update

    cd submodules/baas.io-sdk
    git submodule init
    git submodule update

    cd submodules/usergrid-ios-sdk
    git submodule init
    git submodule update

else
    echo "please install git client."
fi
