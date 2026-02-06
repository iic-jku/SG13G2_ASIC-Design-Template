#!/bin/bash

# =============================================================================
# Make All Files Executable in Git
# =============================================================================
#
# This script:
# 1. Finds all files in the current directory and subdirectories (excluding .git)
# 2. Marks each file as executable in Git's index (100644 -> 100755)
# 3. Stages these permission changes (they'll appear in git status as modified)
#
# After running:
#   git commit -m "Make files executable"
#   git push
#
# Result: Anyone who clones or pulls the repo will get files with the
# executable bit set (100755), meaning they can run scripts directly
# with ./script.sh without needing to chmod first.
# =============================================================================

echo "Making all files executable in Git index..."

git ls-files | xargs git update-index --chmod=-x

echo "Done! Run 'git commit -m \"Make files executable\"' and 'git push' to save changes."