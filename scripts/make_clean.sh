#!/bin/bash
set -e

$WORKSPACE_SCRIPTS/clean.sh
$WORKSPACE_SCRIPTS/make.sh "$@"
