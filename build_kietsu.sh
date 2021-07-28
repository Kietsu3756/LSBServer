#!/bin/bash

# Prepare and build the executables:
if [ ! -d build ]
then
    mkdir build
fi
cd build
cmake ..
make -j $(nproc)