#Gimli computer
#roscore
roslaunch flor_atlas_bringup  common_parameters.launch
roslaunch vigir_ocs common_parameter_setup.launch
roslaunch vigir_onboard vigir_status_relay.launch
roslaunch vigir_ocs vigir_ocs_nodelets_with_footstep_planner.launch
roslaunch vigir_point_cloud_proc vigir_worldmodel.launch
roslaunch vigir_ocs ocs_logging.launch
#roslaunch vigir_comms_bridge ocs_bridge.launch