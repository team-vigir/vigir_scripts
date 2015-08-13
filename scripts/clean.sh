#!/bin/bash

. $WORKSPACE_SCRIPTS/clean_externals.sh

cd $WORKSPACE_ROOT
rm -rf $WORKSPACE_ROOT/build

#rm -rf $WORKSPACE_ROOT/devel
# Remove everything in devel but keep setup.bash and the corresonding things so that the source in .bashrc still works
rm -rf $WORKSPACE_ROOT/devel/bin
rm -rf $WORKSPACE_ROOT/devel/etc
rm -rf $WORKSPACE_ROOT/devel/include
rm -rf $WORKSPACE_ROOT/devel/lib
rm -rf $WORKSPACE_ROOT/devel/share
rm $WORKSPACE_ROOT/devel/.catkin
rm $WORKSPACE_ROOT/devel/.rosinstall


