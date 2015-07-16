#boromir
roslaunch flor_atlas_bringup  common_parameters.launch
#remotelaunch sleep=2.0
roslaunch flor_atlas_bringup multisense_bringup.launch
#remotelaunch sleep=2.0
roslaunch vigir_be_launch behavior_onboard_atlas.launch
roslaunch vigir_onboard perception.launch
roslaunch vigir_wide_angle_image_proc sa_camera_nodelets.launch
roslaunch flor_sa_correction_nodelet correction.launch
#remotelaunch sleep=2.0
roslaunch ms_dynparam ms_dynparam.launch
#
# Relay "tf to "tf_to_field" for single transmission to field
roslaunch vigir_comms_bridge tf_relay_onboard.launch
#
roslaunch vigir_comms_bridge bridge_state_field.launch
#
#roslaunch vigir_comms_bridge_helpers multisense_depth_reducer.launch
#
#
# Lightweight logging for the finals
roslaunch vigir_onboard onboard_logging_finals.launch
#
chrony_tracking.py theoden_robot
