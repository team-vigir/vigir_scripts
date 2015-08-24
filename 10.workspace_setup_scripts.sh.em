#!/bin/sh

@[if DEVELSPACE]@
export WORKSPACE_SCRIPTS=@(PROJECT_SOURCE_DIR)/scripts
@[else]@
export WORKSPACE_SCRIPTS=@(CMAKE_INSTALL_PREFIX)/@(CATKIN_PACKAGE_SHARE_DESTINATION)/scripts
@[end if]@
export WORKSPACE_ROOT=$(cd "@(CMAKE_SOURCE_DIR)/../.."; pwd)

# set THOR_* environment variables
#alias l_vt_hand='. l_vt_hand'
#alias r_vt_hand='. r_vt_hand'
#alias l_thor_mang_hand='. l_thor_mang_hand'
#alias r_thor_mang_hand='. r_thor_mang_hand'

# include THOR_scripts hooks
#if [ -d $WORKSPACE_SCRIPTS ]; then
#  . $WORKSPACE_SCRIPTS/functions.sh
#  . $WORKSPACE_SCRIPTS/robot.sh ""

#  _THOR_include "$WORKSPACE_SCRIPTS/setup.d/*.sh"
#  _THOR_include "$WORKSPACE_SCRIPTS/$HOSTNAME/setup.d/*.sh"

#  if [ -r "$WORKSPACE_SCRIPTS/$HOSTNAME/setup.sh" ]; then
#      echo "Including $WORKSPACE_SCRIPTS/$HOSTNAME/setup.sh..." >&2
#      . "$WORKSPACE_SCRIPTS/$HOSTNAME/setup.sh"
#  fi
#fi

# export additional ROS_PACKAGE_PATH for indigo
if [ "$ROS_DISTRO" = "indigo" ]; then
    export ROS_BOOST_LIB_DIR_NAME=/usr/lib/x86_64-linux-gnu
    export ROS_PACKAGE_PATH=$ROS_PACKAGE_PATH:$ROS_WORKSPACE/../external
fi

# export some variables
export PATH=$WORKSPACE_SCRIPTS/helper:$PATH
export ROS_WORKSPACE=$WORKSPACE_ROOT/src
#export THOR_MOTION_HOSTNAME="thor-motion"
#export THOR_PERCEPTION_HOSTNAME="thor-perception"
#export THOR_ONBOARD_HOSTNAME="thor-motion" #need to be thor-motion because on same machine
#export THOR_FIELD_HOSTNAME="thor-field"
#export ROBOT_HOSTNAMES="thor-motion thor-perception thor-onboard thor-field"
#export ROBOT_USER="thor"
#export THOR_ROBOT_TYPE="thor_mang_hands"
export LEFT_HAND_TYPE="l_vt_hand"
export RIGHT_HAND_TYPE="r_vt_hand"


# Load gazebo setup if gazebo is installed
if [ -f /usr/share/gazebo/setup.sh ]; then
  . /usr/share/gazebo/setup.sh 
fi

# Load drcsim setup if drcsim is installed
if [ -f "/usr/share/drcsim/setup.sh" ]; then

  # If below variable is not set, drcsim setup will overwrite the ROS workspace
  # setup completely. This is also the reason why Gazebo setup is performed separately
  # above (below variable switches off gazebo setup in drcim setup script, too).
  export DRCSIM_SKIP_ROS_GAZEBO_SETUP=true
  source /usr/share/drcsim/setup.sh
fi

# Set BDI interface env variables if it has been detected.
if [ -d "$WORKSPACE_ROOT/bdi_interface/AtlasSimInterface_3.0.2" ];then
  export ATLAS_SIMULATION_INTERFACE=${WORKSPACE_ROOT}/bdi_interface/AtlasSimInterface_3.0.2
  #export ROS_BOOST_LIB_DIR_NAME=/usr/lib/x86_64-linux-gnu
  
  # Required by BDI AtlasInterface. Should check for adverse effects on onboard computers
  ulimit -s unlimited
  ulimit -c unlimited
fi

if [ -d "$WORKSPACE_ROOT/bdi_interface/AtlasRobotInterface_3.3.0" ];then
  export ATLAS_ROBOT_INTERFACE=${WORKSPACE_ROOT}/bdi_interface/AtlasRobotInterface_3.3.0
  export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$ATLAS_ROBOT_INTERFACE/lib64
fi

# adding ssh keys
if [ -d "$WORKSPACE_ROOT/.ssh/" ] && [ "$(ls -A $WORKSPACE_ROOT/.ssh/)" ]; then
    #echo "Adding ssh keys from '$WORKSPACE_ROOT/.ssh/':"
    for f in $WORKSPACE_ROOT/.ssh/*; do
        ssh-add $f
    done
fi
