#!/bin/bash

# =====================================================
# Author: Simon Dorrer
# Last Modified: 26.01.2026
# Description: This .sh file downloads the latest OpenROAD-flow-scripts GitHub repo and updates the template repo.
# =====================================================

set -e -x

cd $(dirname "$0")

# Define variables for cleaner paths
ORFS_REPO_URL="https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts.git"
TEMP_DIR="orfs_temp_download"
TARGET_DIR="orfs"
MAKEFILE_PATH="$TARGET_DIR/flow/Makefile"

# 1. Download ORFS
# Clone depth 1 to save time/bandwidth (we only need the latest files)
echo "Downloading OpenROAD-flow-scripts..."
rm -rf "$TEMP_DIR" # Remove old in case an error happened during the execution of this script
git clone --depth 1 "$ORFS_REPO_URL" "$TEMP_DIR"

# 2. Update env.sh (optional)
# echo "Updating env.sh..."
# cp "$TEMP_DIR/env.sh" "$TARGET_DIR/"

# 3. Update Makefile
echo "Updating Makefile..."
cp "$TEMP_DIR/flow/Makefile" "$TARGET_DIR/flow/"
# Update the comment line
sed -i 's|# Default design$|# Default design (exported in run_orfs.sh)|g' "$MAKEFILE_PATH"
# Update the DESIGN_CONFIG line
sed -i 's|^DESIGN_CONFIG ?= .*|DESIGN_CONFIG ?= ./designs/ihp-sg13g2/counter_board/config.mk|g' "$MAKEFILE_PATH"

# 4. Delete flow artifacts
# Removes logs, objects, reports, and results to ensure a clean state
echo "Cleaning up flow artifacts..."
rm -rf "$TARGET_DIR/flow/logs" "$TARGET_DIR/flow/objects" "$TARGET_DIR/flow/reports" "$TARGET_DIR/flow/results"

# 5. Copy flow/platforms/common
echo "Updating platforms/common..."
rm -rf "$TARGET_DIR/flow/platforms/common" # Remove old to ensure sync
cp -r "$TEMP_DIR/flow/platforms/common" "$TARGET_DIR/flow/platforms/"

# 6. Copy flow/platforms/ihp-sg13g2
echo "Updating platforms/ihp-sg13g2..."
rm -rf "$TARGET_DIR/flow/platforms/ihp-sg13g2" # Remove old
cp -r "$TEMP_DIR/flow/platforms/ihp-sg13g2" "$TARGET_DIR/flow/platforms/"

# 7. Apply Patch: Change RCX_RULES in config.mk
echo "Patching ihp-sg13g2/config.mk..."
CONFIG_FILE="$TARGET_DIR/flow/platforms/ihp-sg13g2/config.mk"
# Use sed to find the commented out export line or the standard export line and replace it
# We use | as a delimiter to handle slashes in paths easily
sed -i 's|# export RCX_RULES = $(PLATFORM_DIR)/rcx_patterns.rules|export RCX_RULES = $(PLATFORM_DIR)/IHP_rcx_patterns.rules|g' "$CONFIG_FILE"
# Also cover the case where it might not be commented in a future update
sed -i 's|^export RCX_RULES = $(PLATFORM_DIR)/rcx_patterns.rules|export RCX_RULES = $(PLATFORM_DIR)/IHP_rcx_patterns.rules|g' "$CONFIG_FILE"
# Delete rcx_patterns.rules
rm -rf "$TARGET_DIR/flow/platforms/ihp-sg13g2/rcx_patterns.rules"

# 8. Copy flow/scripts
echo "Updating flow/scripts..."
rm -rf "$TARGET_DIR/flow/scripts"
cp -r "$TEMP_DIR/flow/scripts" "$TARGET_DIR/flow/"

# 9. Copy flow/test
echo "Updating flow/test..."
rm -rf "$TARGET_DIR/flow/test"
cp -r "$TEMP_DIR/flow/test" "$TARGET_DIR/flow/"

# 10. Copy flow/util
echo "Updating flow/util..."
rm -rf "$TARGET_DIR/flow/util"
cp -r "$TEMP_DIR/flow/util" "$TARGET_DIR/flow/"

# 11. Delete downloaded ORFS folder
echo "Cleaning up temporary files..."
rm -rf "$TEMP_DIR"

# Finish
echo "------ OpenROAD-flow-scripts was successfully updated! ------"