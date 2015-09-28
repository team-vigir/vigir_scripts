#!/bin/bash

if [ -z "$1" ]; then
    export WORKSPACE_ROBOT_TYPE="thor_mang_hands"
    export LEFT_HAND_TYPE="l_vt_hand"
    export RIGHT_HAND_TYPE="r_vt_hand"
else
    if [ -z "$2" ]; then
        echo "Need to give two hands, left and right (e.g. thor hands l_stump r_stump)"
        return
    else
        export WORKSPACE_ROBOT_TYPE="thor_mang_hands"
        export LEFT_HAND_TYPE=$1
        export RIGHT_HAND_TYPE=$2
    fi

fi

echo "  Robot type      = "$WORKSPACE_ROBOT_TYPE
echo "  Left hand type  = "$LEFT_HAND_TYPE
echo "  Right hand type = "$RIGHT_HAND_TYPE
