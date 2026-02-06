// =====================================================
// Author: Simon Dorrer
// Last Modified: 07.12.2024
// Description: This .v file implements a testbench testing the Verilog counter entity.
// =====================================================

`timescale 1ns / 1ps

module counter_tb;

  // Constants
	parameter CLK_FREQ = 8e6;
  parameter COUNTER_MAX = 16;
  parameter COUNTER_BITWIDTH = $clog2(COUNTER_MAX);
	
  // Inputs
  reg clock = 0;
  reg reset_n = 1; // active low reset
  reg enable = 0;

  // Outputs
  wire [COUNTER_BITWIDTH-1:0] counter_value;

  // End of Simulation
  reg tb_end = 0;
  
  // N-Bit Counter (written in Verilog)
  counter_board dut_counter (
    .clock_i(clock),
    .reset_n_i(reset_n),
    .enable_i(enable),
    .counter_value_o(counter_value)
  );
	
	// Generate clock
	/* verilator lint_off STMTDLY */
	always begin
    #((1e9 / (2 * CLK_FREQ))); // Calculate half-period in nanoseconds
    clock = ~clock;
  end
	/* verilator lint_on STMTDLY */
	
	initial begin
		$dumpfile("counter_tb.vcd");
		$dumpvars;
    
    // Reset
    reset_n = 0;
    #(1e9 / CLK_FREQ); // 1 clock period
    reset_n = 1;
    #(1e9 / CLK_FREQ); // 1 clock period
    
    // Test enable
    #(5 * (1e9 / CLK_FREQ)); // 5 clock periods
    enable = 1;
    #(10 * (1e9 / CLK_FREQ)); // 10 clock periods
    enable = 0;
    #(5 * (1e9 / CLK_FREQ)); // 5 clock periods
    enable = 1;
    #(10 * (1e9 / CLK_FREQ)); // 10 clock periods
	
		/* verilator lint_off STMTDLY */
    tb_end = 1;
    $display("End of simulation.");
		$finish; // finish
		/* verilator lint_on STMTDLY */
	end
endmodule // counter_tb