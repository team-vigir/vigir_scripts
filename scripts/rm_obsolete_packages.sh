#!/bin/bash

# This script is for removing packages that were part of a workspace,
# but are not needed anymore. Manual removal is very cumbersome.

. $WORKSPACE_SCRIPTS/rm_from_workspace.sh $WORKSPACE_ROOT/src/external/dynamixel_pro_driver
. $WORKSPACE_SCRIPTS/rm_from_workspace.sh $WORKSPACE_ROOT/src/external/vigir_simple_joint_pan
. $WORKSPACE_SCRIPTS/rm_from_workspace.sh $WORKSPACE_ROOT/src/external/vigir_manipulation_planning
. $WORKSPACE_SCRIPTS/rm_from_workspace.sh $WORKSPACE_ROOT/src/external/vigir_planning_msgs
. $WORKSPACE_SCRIPTS/rm_from_workspace.sh $WORKSPACE_ROOT/src/external/vigir_perception_msgs
. $WORKSPACE_SCRIPTS/rm_from_workspace.sh $WORKSPACE_ROOT/src/external/vigir_lidar_proc
. $WORKSPACE_SCRIPTS/rm_from_workspace.sh $WORKSPACE_ROOT/src/external/vigir_perception
. $WORKSPACE_SCRIPTS/rm_from_workspace.sh $WORKSPACE_ROOT/src/external/vigir_ocs_common
. $WORKSPACE_SCRIPTS/rm_from_workspace.sh $WORKSPACE_ROOT/src/external/vigir_templates
. $WORKSPACE_SCRIPTS/rm_from_workspace.sh $WORKSPACE_ROOT/src/external/flor_rviz
. $WORKSPACE_SCRIPTS/rm_from_workspace.sh $WORKSPACE_ROOT/src/external/vigir_footstep_planning
. $WORKSPACE_SCRIPTS/rm_from_workspace.sh $WORKSPACE_ROOT/src/thor_mang/thor_mang_footstep_planner
. $WORKSPACE_SCRIPTS/rm_from_workspace.sh $WORKSPACE_ROOT/src/thor_mang_vigir_integration
. $WORKSPACE_SCRIPTS/rm_from_workspace.sh $WORKSPACE_ROOT/src/thor_mang/thor_mang_driving
