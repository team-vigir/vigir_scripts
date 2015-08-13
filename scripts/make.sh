#!/bin/bash
set -e

. $WORKSPACE_SCRIPTS/make_externals.sh "$@"

cd $WORKSPACE_ROOT
catkin_make "$@"
