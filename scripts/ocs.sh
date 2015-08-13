#!/bin/bash
if [ "$#" -lt 1 ]; then
  echo "Launching complete ocs."
  roslaunch thor_mang_ocs thor_mang_ocs.launch
else
  command=$1
  shift
  if [ $command == "primary" ]; then
    echo "Starting primary ocs"
    roslaunch thor_mang_ocs primary_ocs.launch "$@"

  elif [ $command == "perception" ]; then
    echo "Starting perception ocs"
    #thor master ocs-primary
    #thor master thor-motion
    roslaunch thor_mang_ocs perception_ocs.launch "$@"  
      
  elif [ $command == "behavior" ]; then
    echo "Starting behavior ocs"
    #thor master ocs-primary
    #thor master thor-motion
    roslaunch thor_mang_ocs behavior_ocs.launch "$@"
    
  elif [ $command == "driving" ]; then
    echo "Starting driving widget"
    roslaunch thor_mang_driving_widget driving_widget.launch "$@"
  else
    echo "Unknown command, launching complete ocs."
    roslaunch thor_mang_ocs thor_mang_ocs.launch
  fi
fi
