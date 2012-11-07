#!/bin/sh

git --version
GIT_IS_AVAILABLE=$?
if [ $GIT_IS_AVAILABLE -eq 0 ]; then
    git submodule update --init --recursive
else
    echo "please install git client."
fi
