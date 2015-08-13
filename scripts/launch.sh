#!/bin/bash

if [ "$1" = "--screen" -a -z "$STY" ]; then
  shift
  SCREEN_SESSION=$1; shift
  thor screen start $SCREEN_SESSION "roslaunch thor_mang_onboard_launch $@"
else
  roslaunch thor_mang_onboard_launch "$@"
fi
