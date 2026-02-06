v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
B 2 1620 -1060 2420 -660 {flags=graph
y1=0.00011
y2=1.5
ypos1=-0.2248735
ypos2=1.2750165
divy=5
subdivy=1
unity=1
x1=4e-07
x2=4.4e-06
divx=5
subdivx=1
xlabmag=1.0
ylabmag=1.0
node="clock
reset_n
enable
b3
b2
b1
b0"
color="4 5 12 10 10 10 10"
dataset=-1
unitx=1
logx=0
logy=0
hilight_wave=-1
linewidth_mult=4
digital=1
legend=1}
B 2 1620 -640 2420 -240 {flags=graph
y1=0.00011
y2=1.5
ypos1=0.00011
ypos2=1.5
divy=5
subdivy=1
unity=1
x1=4e-07
x2=4.4e-06
divx=5
subdivx=1
xlabmag=1.0
ylabmag=1.0
node="clock
reset_n
enable
bits3
bits2
bits1
bits0
BITS;bits3,bits2,bits1,bits0"
color="4 5 12 10 10 10 10 21"
dataset=-1
unitx=1
logx=0
logy=0
hilight_wave=-1
linewidth_mult=4
digital=1
legend=1}
T {Testbench for transient analysis - 4-Bit Counter} 560 -1740 0 0 1 1 {}
N 300 -380 300 -340 {
lab=GND}
N 300 -800 300 -760 {
lab=VDD}
N 300 -700 300 -660 {
lab=GND}
N 300 -480 300 -440 {lab=clock}
N 680 -800 680 -760 {lab=reset_n}
N 680 -700 680 -660 {lab=GND}
N 1160 -840 1200 -840 {lab=clock}
N 1160 -720 1200 -720 {lab=reset_n}
N 1160 -780 1200 -780 {lab=enable}
N 680 -480 680 -440 {lab=enable}
N 680 -380 680 -340 {lab=GND}
N 1360 -840 1400 -840 {lab=b3}
N 1360 -800 1400 -800 {lab=b2}
N 1360 -760 1400 -760 {lab=b1}
N 1360 -720 1400 -720 {lab=b0}
N 1280 -900 1280 -880 {lab=VDD}
N 1280 -680 1280 -660 {lab=GND}
N 1160 -520 1200 -520 {lab=clock}
N 1160 -400 1200 -400 {lab=reset_n}
N 1160 -460 1200 -460 {lab=enable}
N 1280 -580 1280 -560 {lab=VDD}
N 1280 -360 1280 -340 {lab=GND}
N 1360 -500 1400 -500 {lab=bits[0..3] bus=true}
C {devices/vsource.sym} 300 -730 0 0 {name=VDD value="1.5"}
C {devices/gnd.sym} 300 -660 0 0 {name=l6 lab=GND}
C {devices/vdd.sym} 300 -800 0 0 {name=l8 lab=VDD}
C {devices/vsource.sym} 300 -410 0 0 {name=vclk value="pulse(0 1.5 0 10p 10p \{0.5/fclk\} \{1/fclk\})"
}
C {devices/lab_wire.sym} 300 -480 0 0 {name=p2 sig_type=std_logic lab=clock}
C {devices/gnd.sym} 300 -340 0 0 {name=l1 lab=GND}
C {devices/title-3.sym} 0 0 0 0 {name=l3 author="Simon Dorrer" rev=1.0 lock=true}
C {devices/launcher.sym} 1680 -1210 0 0 {name=h2
descr="Simulate" 
tclcommand="xschem save; xschem netlist; xschem simulate"
}
C {devices/launcher.sym} 1680 -1110 0 0 {name=h1
descr="Load waves" 
tclcommand="xschem raw_read $netlist_dir/[file tail [file rootname [xschem get current_name]]].raw tran"
}
C {code_shown.sym} 60 -1650 0 0 {name=NGSPICE
only_toplevel=false
value="
*True Mixed Signal Simulation (.xspice)
.include /foss/designs/SG13G2_ASIC-Design-Template/xspice/counter_board/counter_board.xspice
.include /foss/designs/SG13G2_ASIC-Design-Template/xspice/counter_board/counter_board_bus.xspice

.param temp=27
.param fclk=8000000
.options savecurrents
.control
save all

* Transient Analysis
tran 1n 4u
write counter_board_tb_tran.raw

plot v(clock) v(enable) v(reset_n)
plot v(b3) v(b2) v(b1) v(b0)

* Writing Data
set wr_singlescale
set wr_vecnames

let clock = clock
let enable = enable
let reset_n = reset_n
let b0 = b0
let b1 = b1
let b2 = b2
let b3 = b3

wrdata /foss/designs/SG13G2_ASIC-Design-Template/python/plot_simulations/data/counter_board_tb_tran.txt clock enable reset_n b0 b1 b2 b3

set appendwrite

* Operating Point Analysis
op
remzerovec
write counter_board_tb_tran.raw

* quit
.endc"}
C {devices/lab_wire.sym} 680 -800 0 0 {name=p1 sig_type=std_logic lab=reset_n}
C {devices/gnd.sym} 680 -660 0 0 {name=l2 lab=GND}
C {devices/lab_wire.sym} 1160 -840 0 0 {name=p3 sig_type=std_logic lab=clock}
C {devices/lab_wire.sym} 1160 -720 0 0 {name=p4 sig_type=std_logic lab=reset_n}
C {devices/vsource.sym} 680 -730 0 0 {name=vrst value="pulse(0 1.5 \{1/fclk\} 10p 10p \{0.5/fclk*100\} \{1/fclk*100\})"
}
C {devices/code_shown.sym} 1940 -1190 0 0 {name=MODEL only_toplevel=true
format="tcleval( @value )"
value="
.lib cornerMOSlv.lib mos_tt
.lib cornerRES.lib res_typ
"}
C {devices/gnd.sym} 1280 -660 0 0 {name=l4 lab=GND}
C {devices/vdd.sym} 1280 -900 0 0 {name=l5 lab=VDD}
C {devices/lab_wire.sym} 1160 -780 0 0 {name=p5 sig_type=std_logic lab=enable}
C {devices/gnd.sym} 680 -340 0 0 {name=l9 lab=GND}
C {devices/vsource.sym} 680 -410 0 0 {name=ven value="pulse(0 1.5 \{4/fclk\} 10p 10p \{0.5/fclk*100\} \{1/fclk*100\})"
}
C {devices/lab_wire.sym} 680 -480 0 0 {name=p11 sig_type=std_logic lab=enable}
C {devices/launcher.sym} 1680 -1160 0 0 {name=h3
descr="Annotate OP" 
tclcommand="set show_hidden_texts 1; xschem annotate_op"
}
C {devices/lab_wire.sym} 1400 -840 0 1 {name=p6 sig_type=std_logic lab=b3}
C {devices/lab_wire.sym} 1400 -800 0 1 {name=p7 sig_type=std_logic lab=b2}
C {devices/lab_wire.sym} 1400 -760 0 1 {name=p8 sig_type=std_logic lab=b1}
C {devices/lab_wire.sym} 1400 -720 0 1 {name=p9 sig_type=std_logic lab=b0}
C {counter_board.sym} 1280 -780 0 0 {name=x1}
C {devices/lab_wire.sym} 1160 -520 0 0 {name=p10 sig_type=std_logic lab=clock}
C {devices/lab_wire.sym} 1160 -400 0 0 {name=p12 sig_type=std_logic lab=reset_n}
C {devices/gnd.sym} 1280 -340 0 0 {name=l7 lab=GND}
C {devices/vdd.sym} 1280 -580 0 0 {name=l10 lab=VDD}
C {devices/lab_wire.sym} 1160 -460 0 0 {name=p13 sig_type=std_logic lab=enable}
C {devices/lab_wire.sym} 1400 -500 0 1 {name=p14 sig_type=std_logic lab=bits[0..3]}
C {counter_board_bus.sym} 1280 -460 0 0 {name=x2}
