#legolas
roslaunch flor_atlas_bringup  common_parameters.launch
#remotelaunch sleep=2.0
roslaunch vigir_be_onboard behavior_onboard.launch
roslaunch vigir_onboard onboard_logging.launch
vigir_pronto_start.sh
