#!/bin/bash

set -e

rosclean purge
$WORKSPACE_SCRIPTS/revert.sh
$WORKSPACE_SCRIPTS/new-update.sh
$WORKSPACE_SCRIPTS/make.sh

