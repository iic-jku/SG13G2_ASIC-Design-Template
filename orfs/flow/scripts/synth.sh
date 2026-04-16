#!/usr/bin/env bash
set -u -eo pipefail
mkdir -p $RESULTS_DIR $LOG_DIR $REPORTS_DIR $OBJECTS_DIR
touch $2
$YOSYS_EXE -V > $(realpath $2)
$PYTHON_EXE "$SCRIPTS_DIR/run_command.py" --log "$(realpath $2)" --append --tee -- \
  $YOSYS_EXE $YOSYS_FLAGS -c $1
