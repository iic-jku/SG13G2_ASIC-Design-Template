// =====================================================
// Author: Simon Dorrer
// Last Modified: 07.12.2024
// Description: This .vhd file implements an N-Bit counter with enable in Verilog.
// =====================================================

module counter #(
  parameter COUNTER_BITWIDTH = 4,
  parameter COUNTER_MAX = 15
)(
  input wire clock_i,
  input wire reset_i,
  input wire enable_i,
  
  output wire [COUNTER_BITWIDTH - 1:0] counter_value_o
);
	
  // Internal signals
  reg [COUNTER_BITWIDTH - 1:0] counter_value;
  reg [COUNTER_BITWIDTH - 1:0] next_counter_value;
  // =====================================================
  
  // Register process
  always @(posedge clock_i or posedge reset_i) begin
    if (reset_i) begin
      counter_value <= {COUNTER_BITWIDTH{1'b0}};
    end else if (enable_i) begin
      counter_value <= next_counter_value;
    end
  end
  // =====================================================
  
  // Counter logic
  always @(counter_value) begin
    // Default assignment
    next_counter_value <= counter_value;

    if (counter_value == COUNTER_MAX) begin
      next_counter_value <= {COUNTER_BITWIDTH{1'b0}};
    end else begin
      next_counter_value <= counter_value + 1;
    end
  end
  // =====================================================
  
  // Concurrent statement
	// assign the counter value to the output
  assign counter_value_o = counter_value;
  // =====================================================
endmodule // counter


module counter_board (
  input wire clock_i,
  input wire reset_n_i,  // Active-low reset
  input wire enable_i,
  
  output wire [4-1:0] counter_value_o  // 4-bit counter output
);
  
  // Constants
  parameter COUNTER_MAX = 15;
  parameter COUNTER_BITWIDTH = $clog2(COUNTER_MAX); // = 4
  
  // Inverted Logic for reset input ('1' not pressed, '0' pressed)
  wire reset;

  // Inverting Input Logic
  assign reset = ~reset_n_i;

  // Embed Counter
  counter #(
    .COUNTER_BITWIDTH(COUNTER_BITWIDTH),
    .COUNTER_MAX(COUNTER_MAX)
  ) counter_0 (
    .clock_i(clock_i),
    .reset_i(reset),
    .enable_i(enable_i),
    .counter_value_o(counter_value_o)
  );
  // =====================================================
endmodule // counter_board