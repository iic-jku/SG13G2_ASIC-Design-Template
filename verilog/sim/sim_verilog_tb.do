-- For Simulation in ModelSim
vlib work
vmap work work
vlog -work work ../rtl/counter_board.v
vlog -work work counter_tb.v

vsim work.counter_tb

do wave_verilog.do

run -all