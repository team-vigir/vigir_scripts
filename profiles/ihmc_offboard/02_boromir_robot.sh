#boromir
#remotelaunch sleep=2.0
#roslaunch vigir_onboard motion.launch
#roslaunch flor_atlas_bringup camera_sensors.launch #(has inside the launch files below)
#roslaunch flor_atlas_bringup multisense_bringup.launch
#roslaunch ms_dynparam ms_dynparam.launch
#roslaunch vigir_image_processing onboard_crop_decimate_nodelets.launch
#roslaunch vigir_worldmodel_server worldmodel_default.launch
#roslaunch vigir_state_estimation state_estimation.launch
#roslaunch vigir_lidar_processing lidar_processing.launch
#roslaunch vigir_image_processing relay_multisense_crop_decimate_without_comms_bridge.launch
