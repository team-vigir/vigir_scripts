#!/bin/bash

# build and install thor mang libs
echo
echo ">>> Building THOR-MANG libs"
cd $WORKSPACE_ROOT/src/thor_mang/thor_mang_libs
make "$@"
cd $WORKSPACE_ROOT

