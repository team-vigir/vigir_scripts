#aragorn
#remotelaunch sleep=2.0
roslaunch flor_atlas_bringup  common_parameters.launch
roslaunch vigir_atlas_controller atlas_robot.launch
roslaunch pgr_camera sa_cameras.launch
chrony_tracking.py legolas_robot
