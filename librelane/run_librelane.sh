#!/usr/bin/env bash

# =====================================================
# Author: Simon Dorrer
# Last Modified: 02.10.2025
# Description: This .sh file switches to the ihp-sg13g2 PDK, runs the LibreLane flow and opens the layout in the OpenROAD GUI.
# =====================================================

set -e -x

cd $(dirname "$0")

# Switch to ihp-sg13g2 PDK
source sak-pdk-script.sh ihp-sg13g2 sg13g2_stdcell > /dev/null

# Run LibreLane
librelane --manual-pdk --run-tag latest --overwrite config.yaml

# Open Layout in OpenROAD GUI
librelane --manual-pdk --last-run config.yaml --flow OpenInOpenROAD
