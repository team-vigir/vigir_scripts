#aragorn
#remotelaunch sleep=2.0
ntpdate legolas_robot
roslaunch flor_atlas_bringup  common_parameters.launch
roslaunch vigir_atlas_controller atlas_robot.launch
roslaunch pgr_camera sa_cameras.launch
ntpdate legolas_robot
chrony_tracking.py legolas_robot
