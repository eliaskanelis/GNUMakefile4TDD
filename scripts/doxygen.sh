#!/usr/bin/env bash

# Documentation of C/C++ code

set -euo pipefail

mkdir -p "gen/doc/html"

# Generate doc
export PROJECT_NUMBER="Beta"
export PROJECT_NAME="Untitled"
export PROJECT_BRIEF=""
export PROJECT_LOGO="../../media/logo.png"
export PROJECT_OUTPUT="../../gen/doc"

(cd conf/doxygen/ && doxygen)
