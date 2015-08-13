#!/bin/bash

if [ $# -ne 1 ]
then
  echo "Usage: $0 TARGET_MODE"
  exit -1
fi

TARGET_MODE=$1

echo "Setting target mode: ${TARGET_MODE}"

rostopic pub /mode_controllers/control_mode_controller/change_control_mode/goal vigir_humanoid_control_msgs/ChangeControlModeActionGoal "header:
  seq: 0
  stamp:
    secs: 0
    nsecs: 0
  frame_id: ''
goal_id:
  stamp:
    secs: 0
    nsecs: 0
  id: ''
goal:
  mode_request: '${TARGET_MODE}'"