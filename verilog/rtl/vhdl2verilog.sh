#!/usr/bin/env bash

# =====================================================
# Author: Simon Dorrer
# Last Modified: 07.12.2024
# Description: This .sh file converts the VHDL files into one Verilog file.
# =====================================================

set -e -x

cd $(dirname "$0")

# Name as input parameter (counter)
name=$1

RTL=${RTL:-../../vhdl/rtl}
SRC_FOLDER=${SRC_FOLDER:-.}

mkdir -p build

# Analyze sources
ghdl -a --std=93c --work=counter --workdir=build -Pbuild \
  "$RTL"/constants_p.vhd \
  "$RTL"/"$name"_ea.vhd \
  "$RTL"/"$name"_board.vhd

# Top entity
ghdl -m --std=93c --work=counter --workdir=build -Pbuild "$name"_board

# Synthesize: generate Verilog output
ghdl synth --std=93c --no-formal --work=counter --workdir=build -Pbuild --out=verilog "$name"_board > "$SRC_FOLDER"/"$name"_board.v

# Show interface of generated Verilog module
echo ""
echo "------ "$name"_board interface ------"
sed -n "/module "$name"_board/,/);/p" "$SRC_FOLDER"/"$name"_board.v
echo ""