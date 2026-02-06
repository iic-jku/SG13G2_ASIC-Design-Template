#!/usr/bin/env bash

# =====================================================
# Master's Thesis: Threshold-Based Sampling ASIC with FOSS tools.
# Author: Simon Dorrer
# Last Modified: 01.05.2025
# Description: This .sh file loads the Verilog file and outputs stats, such as cells, AND, OR, NOT, XOR, MUX, and registers.
# =====================================================

set -e -x

cd $(dirname "$0")

# Name as input parameter (atbs_core_floating_window, atbs_core_fixed_window)
name=$1

yosys -p "read_verilog "$name"_board.v; proc; opt; flatten; techmap; stat"