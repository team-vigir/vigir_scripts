#!/bin/bash

roslaunch vigir_comms_bridge thor_mang_ocs.launch
thor ssh $WORKSPACE_FIELD_HOSTNAME "thor field $command"


