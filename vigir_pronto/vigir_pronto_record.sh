#!/bin/bash

export PATH=$VIGIR_ROOT_DIR/pronto-distro/build/bin:$PATH
export PKG_CONFIG_PATH=$VIGIR_ROOT_DIR/pronto-distro/build/lib/pkgconfig/:$VIGIR_ROOT_DIR/pronto-distro/build/lib64/pkgconfig/:$PKG_CONFIG_PATH
export LD_LIBRARY_PATH=$VIGIR_ROOT_DIR/pronto-distro/build/lib/:$VIGIR_ROOT_DIR/pronto-distro/build/lib64/:$LD_LIBRARY_PATH

echo "This script records all data on LCM data to a lcm log file."

lcm-logger

# Below can be used in case of non-functional f/t sensing
#se-fusion -v -U atlas_v4/model_LR_RR.urdf -P drc_robot_02_mit_no_laser.cfg

