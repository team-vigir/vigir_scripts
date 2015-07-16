#!/bin/bash
#remotelaunch sleep=0.5

echo 'Starting main controller on Aragorn...'

# Without comms bridge
#roslaunch vigir_atlas_controller atlas_controller.launch
mkdir /home/testing/vigir_repo/test
#comms bridge
#roslaunch vigir_onboard_machines basic_controller_setup.launch
#roslaunch vigir_atlas_controller atlas_controller.launch
roslaunch vigir_atlas_controller start_controller_default.launch

