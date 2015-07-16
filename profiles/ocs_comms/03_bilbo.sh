# Bilbo - Aux operator station
roslaunch flor_atlas_bringup  common_parameters.launch
roslaunch vigir_ocs common_parameter_setup.launch
roslaunch vigir_ocs vigir_desktop_recorder.launch
chrony_tracking.py gandalf
# roslaunch vigir_ocs vigir_aux_ui.launch manually due to UI
