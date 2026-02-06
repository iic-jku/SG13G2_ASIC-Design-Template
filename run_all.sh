#!/bin/bash

# =====================================================
# Author: Simon Dorrer
# Last Modified: 02.04.2025
# Description: This .sh file runs all self-written shell scripts (vhdl2verilog, run_orfs, verilog2xspice) for the given folder structure.
# This is a convenient way to design analog-digital ASICs.
# =====================================================

set -e -x

cd $(dirname "$0")

# Parse arguments
language="vhdl" # default
sim_flag=

# Check if no arguments were passed
if [ $# -eq 0 ]; then
  echo "No arguments provided."
  echo "Use -h for help."
  exit 1
fi

# Parse flags
while [[ $# -gt 0 ]]; do
  case "$1" in
    -s|--sim)
      sim_flag=true
      shift
      ;;
    -l|--layout)
      sim_flag=false
      shift
      ;;
    --vhdl)
      language="vhdl"
      shift
      ;;
    --verilog)
      language="verilog"
      shift
      ;;
    -h|--help)
      echo "Usage:"
      echo "  $0 [-s|--sim | -l|--layout] [--vhdl | --verilog] <name>"
      echo "    -s or --sim:     Run simulation (no layout)"
      echo "    -l or --layout:  Generate layout"
      echo "    --vhdl:          Use VHDL (default)"
      echo "    --verilog:       Use Verilog"
      echo "    <name>:          Design name (required)"
      exit 0
      ;;
    -*)
      echo "Unknown option: $1"
      echo "Use -h for help."
      exit 1
      ;;
    *)
      name="$1"
      shift
      ;;
  esac
done

# Validate required fields
if [ -z "$sim_flag" ]; then
  echo "Error: Mode (-s or -l) must be specified."
  echo "Use -h for help."
  exit 1
fi

if [ -z "$language" ]; then
  echo "No language specified. Defaulting to vhdl."
  language="vhdl"
fi

if [ -z "$name" ]; then
  echo "Error: Design name is required."
  echo "Use -h for help."
  exit 1
fi

# Initialize variables
suffix="board"
VERILOG=${VERILOG:-verilog/rtl}
ORFS=${ORFS:-orfs}
XSPICE=${XSPICE:-xspice}
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)

# First, clean all
./clean_all.sh "$name" || true

if [ "$language" = "vhdl" ]; then
  # Run "vhdl2verilog.sh"
  cd "$VERILOG"
  ./vhdl2verilog.sh "$name"
  cd "$SCRIPT_DIR"
fi

if [ "$sim_flag" = true ]; then
  # Run "run_orfs.sh" - Simulation Only
  cd "$ORFS"
  ./run_orfs.sh --sim "$name"_"$suffix"
  cd "$SCRIPT_DIR"
  
  # Run "verilog2xspice.sh"
  cd "$XSPICE"
  ./verilog2xspice.sh "$name"_"$suffix"
  cd "$SCRIPT_DIR"
  
  # Run "yosys_stats.sh"
  cd "$VERILOG"
  ./yosys_stats.sh "$name"
  cd "$SCRIPT_DIR"
else
  # Layout
  cd "$ORFS"
  ./run_orfs.sh --layout "$name"_"$suffix"
  cd "$SCRIPT_DIR"
fi

# Finish
echo "------ The complete flow was successful! ------"