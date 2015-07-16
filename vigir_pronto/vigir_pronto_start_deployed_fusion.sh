#!/bin/bash

export PATH=$VIGIR_ROOT_DIR/pronto-distro/build/bin:$PATH
export PKG_CONFIG_PATH=$VIGIR_ROOT_DIR/pronto-distro/build/lib/pkgconfig/:$VIGIR_ROOT_DIR/pronto-distro/build/lib64/pkgconfig/:$PKG_CONFIG_PATH
export LD_LIBRARY_PATH=$VIGIR_ROOT_DIR/pronto-distro/build/lib/:$VIGIR_ROOT_DIR/pronto-distro/build/lib64/:$LD_LIBRARY_PATH

se-fusion -v -U ${VIGIR_ROOT_DIR}/pronto-distro/build/models/atlas_v5/model_LR_RR.urdf -P ${VIGIR_ROOT_DIR}/pronto-distro/build/config/drc_robot_vigir_no_laser.cfg

