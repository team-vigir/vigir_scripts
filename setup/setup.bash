#!/bin/bash

#Make fuerte and groovy setup scripts be able to manipulate the environment through aliasing
# this way we won't forget the dot and screw things up
alias vigir='cd ${VIGIR_ROOT_DIR}'
alias sim='. sim'
alias vig='. vig'
alias ocs='. ocs'
alias atlas='. atlas'
alias atlas_boston='. atlas_boston'
alias atlas_sim='. atlas_sim'
alias atlas_irobot='. atlas_irobot'
alias atlas_sandia='. atlas_sandia'
alias atlas_hooks='. atlas_hooks'
alias atlas_stumps='. atlas_stumps'
alias atlas_multisense='. atlas_multisense'
alias atlas_hose_task='. atlas_hose_task'
alias atlas_door_task='. atlas_door_task'
alias atlas_debris_task='. atlas_debris_task'
alias atlas_terrain_task='. atlas_terrain_task'
alias atlas_wall_task='. atlas_wall_task'
alias atlas_valve_task='. atlas_valve_task'
alias atlas_ladder_task='. atlas_ladder_task'
alias atlas_vehicle_task='. atlas_vehicle_task'
alias atlas_calibration='. atlas_calibration'
alias ros_gandalf='. ros_gandalf'
alias ros_gimli='. ros_gimli'
alias ros_frodo='. ros_frodo'
alias ros_aragorn='. ros_aragorn'
alias ros_legolas='. ros_legolas'
alias ros_sam='. ros_sam'
alias ros_pippin='. ros_pippin'
alias ros_bilbo='. ros_bilbo'
alias ros_arwen='. ros_arwen'
alias ros_gandalf_field='. ros_gandalf_field'
alias ros_gimli_field='. ros_gimli_field'
alias ros_frodo_field='. ros_frodo_field'
alias ros_aragorn_field='. ros_aragorn_field'
alias ros_legolas_field='. ros_legolas_field'
alias ros_sam_field='. ros_sam_field'
alias ros_pippin_field='. ros_pippin_field'
alias ros_bilbo_field='. ros_bilbo_field'
alias ros_arwen_field='. ros_arwen_field'
alias ros_gandalf_robot='. ros_gandalf_robot'
alias ros_gimli_robot='. ros_gimli_robot'
alias ros_frodo_robot='. ros_frodo_robot'
alias ros_aragorn_robot='. ros_aragorn_robot'
alias ros_legolas_robot='. ros_legolas_robot'
alias ros_sam_robot='. ros_sam_robot'
alias ros_pippin_robot='. ros_pippin_robot'
alias ros_boromir_robot='. ros_boromir_robot'
alias ros_theoden_robot='. ros_theoden_robot'
alias ros_eowyn_robot='. ros_eowyn_robot'
alias ros_bilbo_robot='. ros_bilbo_robot'
alias ros_arwen_robot='. ros_arwen_robot'
alias l_irobot='. l_irobot'
alias l_robotiq='. l_robotiq'
alias l_robotiq_guard='. l_robotiq_guard'
alias l_no_guard='. l_no_guard'
alias l_irobot_with_extension='. l_irobot_with_extension'
alias l_sandia='. l_sandia'
alias l_hook='. l_hook'
alias l_payload='. l_payload'
alias l_stump='. l_stump'
alias l_checkerboard='. l_checkerboard'
alias r_irobot='. r_irobot'
alias r_robotiq='. r_robotiq'
alias r_robotiq_guard='. r_robotiq_guard'
alias r_no_guard='. r_no_guard'
alias r_sandia='. r_sandia'
alias r_hook='. r_hook'
alias r_payload='. r_payload'
alias r_stump='. r_stump'
alias r_checkerboard='. r_checkerboard'
alias sandias='. sandias'
alias hooks='. hooks'
alias payloads='. payloads'
alias robotiqs='. robotiqs'
alias irobots='. irobots'
alias stumps='. stumps'
alias guards_robotiq='. guards_robotiq'
alias guards_no='. guards_no'
alias onboard_gazebo='. onboard_gazebo'

if [ -z "$VIGIR_ROOT_DIR" ]; then
   if [ -z "$ROS_WORKSPACE" ]; then
	echo
	echo "-------------------------------------------------------------------------"
	echo "-------------------------------------------------------------------------"
	echo
	echo " The VIGIR_ROOT_DIR (e.g. ~/vigir_repo ) is not set.  "
	echo " This must be set for the scripts and build system to work correctly!"
	echo
	echo " Please correct in the .bashrc and re-start shell!"
	echo
	echo "-------------------------------------------------------------------------"
	echo "-------------------------------------------------------------------------"
	echo
   else
	echo "Using ROS_WORKSPACE to set the VIGIR_ROOT_DIR ... confirm correctness"
	export VIGIR_ROOT_DIR=${ROS_WORKSPACE}/..
	echo "VIGIR_ROOT_DIR=${VIGIR_ROOT_DIR}"
   fi

else
	echo "Use 'vigir' to change to the base installation directory (cd \${VIGIR_ROOT_DIR})" 
	echo "Set up aliases to change terminal:"
	echo "   OCS catkin setup  run 'ocs' command"
	echo "ROS Master aliases used to specify where the ROS master is running"
	echo "   'ros_frodo', 'ros_gandalf', 'ros_gimli', 'ros_frodo', 'ros_aragorn', 'ros_legolas', 'ros_sam',"
	echo " and the corresponding _field network (e.g. ros_frodo_field)"

	export ROS_LANG_DISABLE=genlisp

	#Setup non ROS paths
	export PATH=${VIGIR_ROOT_DIR}/scripts/helpers:${VIGIR_ROOT_DIR}/scripts/vigir_pronto:${VIGIR_ROOT_DIR}:$PATH

	export ATLAS_SIMULATION_INTERFACE=${VIGIR_ROOT_DIR}/flor_atlas_robot_interface/AtlasSimInterface_3.0.2
        export ATLAS_ROBOT_INTERFACE=${VIGIR_ROOT_DIR}/flor_atlas_robot_interface/AtlasRobotInterface_3.3.0
	export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$ATLAS_ROBOT_INTERFACE/lib64
	export ROS_BOOST_LIB_DIR_NAME=/usr/lib/x86_64-linux-gnu

	#Setup default indigo environment
	vig

	# Temp fixes for indigo, export path to pass through packages
	export ROS_PACKAGE_PATH=$ROS_PACKAGE_PATH:${VIGIR_ROOT_DIR}/catkin_ws/external
fi

