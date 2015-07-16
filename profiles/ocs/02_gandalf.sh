# Gandalf - Main operator station
roslaunch flor_atlas_bringup  common_parameters.launch
roslaunch vigir_ocs common/common_parameter_setup.launch
roslaunch vigir_ocs vigir_desktop_recorder.launch
# roslaunch vigir_ocs vigir_main_ui.launch manually due to UI
