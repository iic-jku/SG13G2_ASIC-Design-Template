#!/usr/bin/env bash
function __setpaths() {
  if [[ "$OSTYPE" == "darwin"* ]]; then
    DIR="$(dirname $(perl -e 'use Cwd "abs_path";print abs_path(shift)' "${BASH_SOURCE[0]:-${(%):-%x}}"))"
  else
    DIR="$(dirname $(readlink -f "${BASH_SOURCE[0]:-${(%):-%x}}"))"
  fi

  # $TOOLS = /foss/tools
  export OPENROAD=$TOOLS/openroad
  echo "OpenROAD: ${OPENROAD}"

  export OPENROAD_EXE=$TOOLS/openroad/bin/openroad
  echo "OpenROAD EXE: ${OPENROAD_EXE}"

  export OPENSTA_EXE=$TOOLS/openroad/bin/sta
  echo "OpenSTA EXE: ${OPENSTA_EXE}"

  export YOSYS_EXE=$TOOLS/yosys/bin/yosys
  echo "Yosys EXE : ${YOSYS_EXE}"

  export KLAYOUT_DIR=$TOOLS/klayout
  echo "KLayout DIR: ${KLAYOUT_DIR}"

  if [[ "$OSTYPE" == "darwin"* ]]; then
    export PATH="/Applications/KLayout/klayout.app/Contents/MacOS:$PATH"
    export PATH="$(brew --prefix bison)/bin:$(brew --prefix flex)/bin:$(brew --prefix tcl-tk)/bin:$PATH"
  fi

  export FLOW_HOME=$DIR/flow
}
__setpaths
unset -f __setpaths
