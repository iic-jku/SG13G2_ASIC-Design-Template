#!/bin/bash

# =====================================================
# Author: Simon Dorrer
# Last Modified: 26.01.2026
# Description: This .sh file downloads the latest OpenROAD-flow-scripts GitHub repo and insert the required file to the template repo.
# =====================================================

set -e -x

cd $(dirname "$0")

# Download ORFS
# https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts

# Extract files

# update env.sh (optional)

# update Makefile
# change header

# delete flow/logs, flow/objects, flow/reports, flow/results

# copy flow/platforms/common

# copy flow/platforms/ihp-sg13g2

# copy flow/scripts

# copy flow/test

# copy flow/util

# delete downloaded ORFS folder

# Finish
echo "------ OpenROAD-flow-scripts was successfully updated! ------"