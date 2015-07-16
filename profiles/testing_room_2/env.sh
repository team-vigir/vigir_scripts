#!/bin/bash

cmdline=("$@")
if [ $# == 0 ]; then
    cmdline=($SHELL -i)
fi

export VIGIR_ROOT_DIR=/home/testing/vigir_repo
echo "sourcing catkin_ws................"
source "/home/testing/vigir_repo/catkin_ws/install/setup.bash"
echo "sourcing scripts setup.bash.................."
source "/home/testing/vigir_repo/scripts/setup/setup.bash"
shopt -s expand_aliases
# Set up scripts for ROS networking
alias set_ocs_ros_hostname='export ROS_HOSTNAME=$HOSTNAME'
alias set_field_ros_hostname='export ROS_HOSTNAME='$HOSTNAME'_field'
source atlas_sim
source ros_sam

exec "${cmdline[@]}"
