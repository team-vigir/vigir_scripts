#legolas
#remotelaunch sleep=1.0
roslaunch vigir_onboard_gazebo onboard_perception_gazebo.launch
roslaunch vigir_image_processing relay_multisense_crop_decimate_without_comms_bridge.launch