#!/bin/bash

export PATH=$VIGIR_ROOT_DIR/pronto-distro/build/bin:$PATH
export PKG_CONFIG_PATH=$VIGIR_ROOT_DIR/pronto-distro/build/lib/pkgconfig/:$VIGIR_ROOT_DIR/pronto-distro/build/lib64/pkgconfig/:$PKG_CONFIG_PATH
export LD_LIBRARY_PATH=$VIGIR_ROOT_DIR/pronto-distro/build/lib/:$VIGIR_ROOT_DIR/pronto-distro/build/lib64/:$LD_LIBRARY_PATH

echo "------------------------------"
echo "Building pronto for deployment"
echo "------------------------------"

cd ${VIGIR_ROOT_DIR}/pronto-distro/

make

message=$?
#Case there is error
if [ $message != 0 ] ; then echo "Error in executing pronto make"; exit 1; fi

cd pronto-lcm-ros-translators
catkin_make install -DCMAKE_INSTALL_PREFIX=${VIGIR_ROOT_DIR}/catkin_ws/install

message=$?
#Case there is error
if [ $message != 0 ] ; then echo $message; echo "Error in installing pronto "; exit 1; fi

echo "------------------------------"
echo "Finished building pronto and installed to ViGIR install folder"
echo "------------------------------"
