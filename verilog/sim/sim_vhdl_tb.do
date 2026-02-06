-- For Simulation in ModelSim
vlib work
vmap work work
vlog -work work ../rtl/counter_board.v
vcom -work work counter_tb.vhd

vsim work.counter_tb

do wave_vhdl.do

when -label end_of_simulation {tb_end == '1'} {echo "End of simulation" ; stop;}
run -a