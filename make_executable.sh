#!/bin/bash

# =============================================================================
# Make Selected Scripts Executable
# =============================================================================
#
# This script sets executable permissions only for the listed scripts.
# Run it from the repository root.
# =============================================================================

set -e

echo "Making selected scripts executable..."

chmod +x \
	update_orfs.sh \
	run_all.sh \
	make_executable.sh \
	clean_all.sh \
	xspice/verilog2xspice.sh \
	vhdl/sim/simulate_vhdl.sh \
	verilog/rtl/vhdl2verilog.sh \
	verilog/rtl/yosys_stats.sh \
	verilog/sim/simulate_verilog.sh \
	orfs/env.sh \
	orfs/run_orfs.sh

echo "Done."