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
echo "Connecting to Eowyn for ROS master using Robot network ..."
export ROS_MASTER_URI=http://gimli:11311
export ROS_HOSTNAME=$HOSTNAME
source atlas
source l_robotiq
source r_robotiq
export FLOR_MULTISENSE_TYPE=real

echo "Start the script..."
eval "${cmdline[@]}"

echo "Send foo if we get here without a pkill ..."
cmd_text="Premature exit! - "$HOSTNAME" -"
for f in ${cmdline[@]}
  do
    cmd_text=$cmd_text" "$f
  done
echo $cmd_text

rostopic pub /vigir_foobar std_msgs/String "$cmd_text"

echo "Finished the script!"
bash --norc --noprofile
