#!/bin/bash

cmdline=("$@")
if [ $# == 0 ]; then
    cmdline=($SHELL -i)
fi

export VIGIR_ROOT_DIR=/home/demo/vigir_repo
echo "sourcing catkin_ws................"
source "/home/demo/vigir_repo/catkin_ws/install/setup.bash"
echo "sourcing scripts setup.bash.................."
source "/home/demo/vigir_repo/scripts/setup/setup.bash"
shopt -s expand_aliases
export ros_arwen
export ROS_MASTER_URI=http://arwen:11311
source atlas
source robotiqs
export FLOR_MULTISENSE_TYPE=sim



exec "${cmdline[@]}"
