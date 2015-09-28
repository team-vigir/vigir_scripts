#!/bin/bash
set -e

$WORKSPACE_SCRIPTS/revert.sh
$WORKSPACE_SCRIPTS/new-update.sh --no-merge
$WORKSPACE_SCRIPTS/make.sh
