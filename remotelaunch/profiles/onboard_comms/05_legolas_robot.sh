#legolas
roslaunch flor_atlas_bringup common_parameters.launch
#remotelaunch sleep=2.0
#
roslaunch vigir_atlas_comms_bridge slow_field.launch
#
# laser to compressed laser and bridge handling converter
roslaunch vigir_comms_bridge bridge_laser_field.launch
#
# Relay "tf_to_field" to "tf_on_field"
roslaunch vigir_comms_bridge tf_relay_field.launch
#
# Start these guys on field. The tf data they need is provided on the "tf_on_field" topic.
roslaunch vigir_comms_bridge_helpers multisense_left_reducer.launch
roslaunch vigir_comms_bridge_helpers hands_reducer.launch
#
# fast bridge nodes
roslaunch vigir_comms_bridge fast_field.launch
roslaunch vigir_comms_bridge fast_field_hands.launch
roslaunch vigir_comms_bridge fast_field_laser.launch
#roslaunch vigir_comms_bridge fast_field_multisense_depth.launch
roslaunch vigir_comms_bridge fast_field_multisense_left.launch
#
#roslaunch vigir_be_launch behavior_onboard_atlas.launch
#
#
#roslaunch vigir_onboard onboard_logging.launch
#roslaunch vigir_onboard onboard_logging_2.launch
