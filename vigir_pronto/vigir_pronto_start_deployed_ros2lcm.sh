#!/bin/bash

export PATH=$VIGIR_ROOT_DIR/pronto-distro/build/bin:$PATH
export PKG_CONFIG_PATH=$VIGIR_ROOT_DIR/pronto-distro/build/lib/pkgconfig/:$VIGIR_ROOT_DIR/pronto-distro/build/lib64/pkgconfig/:$PKG_CONFIG_PATH
export LD_LIBRARY_PATH=$VIGIR_ROOT_DIR/pronto-distro/build/lib/:$VIGIR_ROOT_DIR/pronto-distro/build/lib64/:$LD_LIBRARY_PATH

cd ${VIGIR_ROOT_DIR}/catkin_ws/install/lib/pronto_translators
./ros2lcm

#roslaunch pronto_translators vigir_pronto_translators.launch

#se-fusion -U ${VIGIR_ROOT_DIR}/pronto-distro/build/models/atlas_v4/model_LR_RR.urdf -P ${VIGIR_ROOT_DIR}/pronto-distro/build/config/drc_robot_02_mit_no_laser.cfg

# Below can be used in case of non-functional f/t sensing
#se-fusion -v -U atlas_v4/model_LR_RR.urdf -P drc_robot_02_mit_no_laser.cfg

