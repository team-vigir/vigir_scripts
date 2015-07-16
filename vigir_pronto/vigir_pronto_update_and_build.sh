#!/bin/bash

export PATH=$VIGIR_ROOT_DIR/pronto-distro/build/bin:$PATH
export PKG_CONFIG_PATH=$VIGIR_ROOT_DIR/pronto-distro/build/lib/pkgconfig/:$VIGIR_ROOT_DIR/pronto-distro/build/lib64/pkgconfig/:$PKG_CONFIG_PATH
export LD_LIBRARY_PATH=$VIGIR_ROOT_DIR/pronto-distro/build/lib/:$VIGIR_ROOT_DIR/pronto-distro/build/lib64/:$LD_LIBRARY_PATH

cd ${VIGIR_ROOT_DIR}/pronto-distro/
git pull origin vigir_config_lab
git checkout vigir_config_lab

# Update both git submodule folders
# Not sure if there's a better way, but
# below seems to work.
cd pronto
git pull origin master
cd ../kinematics-utils
git pull origin master
cd ..
make

cd pronto-lcm-ros-translators
catkin_make