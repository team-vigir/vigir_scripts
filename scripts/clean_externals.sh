#!/bin/bash

# build and install sbpl by source
echo
echo ">>> Cleaning SPBL"
cd $WORKSPACE_ROOT/src/external/sbpl
rm -rf build
cd $WORKSPACE_ROOT

# build and install thor mang libs
echo
echo ">>> Cleaning THOR-MANG libs"
cd $WORKSPACE_ROOT/src/thor_mang/thor_mang_libs
rm -rf build lib
cd $WORKSPACE_ROOT
