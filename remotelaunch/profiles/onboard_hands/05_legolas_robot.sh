#legolas
roslaunch flor_atlas_bringup  common_parameters.launch
#remotelaunch sleep=2.0
roslaunch vigir_be_launch behavior_onboard_atlas.launch
roslaunch vigir_onboard onboard_logging.launch
