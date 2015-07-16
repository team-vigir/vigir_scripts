#Gimli computer
#roscore
roslaunch flor_atlas_bringup  common_parameters.launch
roslaunch vigir_ocs common/common_parameter_setup.launch
roslaunch vigir_ocs vigir_desktop_recorder.launch
#roslaunch vigir_ocs vigir_ocs_supervisor.launch manually
