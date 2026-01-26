module counter_board (clock_i,
    enable_i,
    reset_n_i,
    counter_value_o);
 input clock_i;
 input enable_i;
 input reset_n_i;
 output [3:0] counter_value_o;

 wire net3;
 wire net4;
 wire net5;
 wire net6;
 wire n1;
 wire \counter_0/_00_ ;
 wire \counter_0/_01_ ;
 wire \counter_0/_02_ ;
 wire \counter_0/_03_ ;
 wire \counter_0/_04_ ;
 wire \counter_0/_05_ ;
 wire \counter_0/_06_ ;
 wire \counter_0/_07_ ;
 wire net1;
 wire net2;
 wire clknet_0_clock_i;
 wire clknet_1_0__leaf_clock_i;
 wire clknet_1_1__leaf_clock_i;

 sg13g2_inv_2 _0_ (.Y(n1),
    .A(net2));
 sg13g2_inv_1 \counter_0/_08_  (.Y(\counter_0/_00_ ),
    .A(n1));
 sg13g2_xor2_1 \counter_0/_09_  (.B(net1),
    .A(net3),
    .X(\counter_0/_01_ ));
 sg13g2_nand2_1 \counter_0/_10_  (.Y(\counter_0/_05_ ),
    .A(net3),
    .B(net1));
 sg13g2_xnor2_1 \counter_0/_11_  (.Y(\counter_0/_02_ ),
    .A(net4),
    .B(\counter_0/_05_ ));
 sg13g2_nand3_1 \counter_0/_12_  (.B(net4),
    .C(net1),
    .A(net3),
    .Y(\counter_0/_06_ ));
 sg13g2_xnor2_1 \counter_0/_13_  (.Y(\counter_0/_03_ ),
    .A(net5),
    .B(\counter_0/_06_ ));
 sg13g2_nand4_1 \counter_0/_14_  (.B(net4),
    .C(net5),
    .A(net3),
    .Y(\counter_0/_07_ ),
    .D(net1));
 sg13g2_xnor2_1 \counter_0/_15_  (.Y(\counter_0/_04_ ),
    .A(net6),
    .B(\counter_0/_07_ ));
 sg13g2_dfrbpq_1 \counter_0/n20[0]$_DFFE_PP0P_  (.RESET_B(\counter_0/_00_ ),
    .D(\counter_0/_01_ ),
    .Q(net3),
    .CLK(clknet_1_1__leaf_clock_i));
 sg13g2_dfrbpq_1 \counter_0/n20[1]$_DFFE_PP0P_  (.RESET_B(\counter_0/_00_ ),
    .D(\counter_0/_02_ ),
    .Q(net4),
    .CLK(clknet_1_1__leaf_clock_i));
 sg13g2_dfrbpq_1 \counter_0/n20[2]$_DFFE_PP0P_  (.RESET_B(\counter_0/_00_ ),
    .D(\counter_0/_03_ ),
    .Q(net5),
    .CLK(clknet_1_0__leaf_clock_i));
 sg13g2_dfrbpq_1 \counter_0/n20[3]$_DFFE_PP0P_  (.RESET_B(\counter_0/_00_ ),
    .D(\counter_0/_04_ ),
    .Q(net6),
    .CLK(clknet_1_0__leaf_clock_i));
 sg13g2_buf_1 input1 (.A(enable_i),
    .X(net1));
 sg13g2_buf_1 input2 (.A(reset_n_i),
    .X(net2));
 sg13g2_buf_1 output3 (.A(net3),
    .X(counter_value_o[0]));
 sg13g2_buf_1 output4 (.A(net4),
    .X(counter_value_o[1]));
 sg13g2_buf_1 output5 (.A(net5),
    .X(counter_value_o[2]));
 sg13g2_buf_1 output6 (.A(net6),
    .X(counter_value_o[3]));
 sg13g2_buf_2 clkbuf_0_clock_i (.A(clock_i),
    .X(clknet_0_clock_i));
 sg13g2_buf_2 clkbuf_1_0__f_clock_i (.A(clknet_0_clock_i),
    .X(clknet_1_0__leaf_clock_i));
 sg13g2_buf_2 clkbuf_1_1__f_clock_i (.A(clknet_0_clock_i),
    .X(clknet_1_1__leaf_clock_i));
endmodule
