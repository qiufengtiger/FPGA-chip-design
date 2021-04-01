module fpga_edge(right_in, right_out, top_in, top_out, 
    right_sb_in, right_clb_in, top_clb_in,
    scan_clk, conn_scan_en, conn_scan_in, conn_scan_out, fpga_in, fpga_out
);
	parameter CHANNEL_ONEWAY_WIDTH = 4;

    input conn_scan_en, conn_scan_in, scan_clk;
    output conn_scan_out;
    input [31:0] right_in, top_in;
    output [31:0] right_out, top_out;
    input [7:0] right_sb_in;
    output [7:0] right_clb_in, top_clb_in;
	input [9:0] fpga_in;
	output [9:0] fpga_out;
    wire conn_scan_conn_0, conn_scan_conn_1, conn_scan_conn_2, conn_scan_conn_3, conn_scan_conn_4, conn_scan_conn_5, conn_scan_conn_6;
	wire conn_scan_conn_7, conn_scan_conn_8, conn_scan_conn_9, conn_scan_conn_10, conn_scan_conn_11, conn_scan_conn_12, conn_scan_conn_13,
		conn_scan_conn_14, conn_scan_conn_15, conn_scan_conn_16, conn_scan_conn_17, conn_scan_conn_18, conn_scan_conn_19, conn_scan_conn_20,
		conn_scan_conn_21, conn_scan_conn_22, conn_scan_conn_23, conn_scan_conn_24, conn_scan_conn_25, conn_scan_conn_26, conn_scan_conn_27,
		conn_scan_conn_28, conn_scan_conn_29, conn_scan_conn_30, conn_scan_conn_31;


    wire [3:0] sb_0_sb_1, sb_1_sb_0, sb_1_sb_2, sb_2_sb_1, sb_2_sb_3, sb_3_sb_2, sb_3_sb_4, sb_4_sb_3,
									sb_4_sb_5, sb_5_sb_4, sb_5_sb_6, sb_6_sb_5, sb_6_sb_7, sb_7_sb_6, sb_7_sb_8, sb_8_sb_7, sb_8_sb_9, sb_9_sb_8, 
									sb_9_sb_10, sb_10_sb_9, sb_10_sb_11, sb_11_sb_10, sb_11_sb_12, sb_12_sb_11, sb_12_sb_13, sb_13_sb_12, sb_13_sb_14,
									sb_14_sb_13, sb_14_sb_15, sb_15_sb_14, sb_15_sb_16, sb_16_sb_15;

    wire [3:0] dummy_leftin_sb_0;
    assign dummy_leftin_sb_0[1:0] = 3'b00;
    assign dummy_leftin_sb_0[2] = fpga_in[0];
    assign dummy_leftin_sb_0[3] = 1'b0;

	//Top left corner
    switch_block #(CHANNEL_ONEWAY_WIDTH) inst_sb_0(
		.scan_clk(scan_clk), 
		.left_in(dummy_leftin_sb_0), 
		.right_in(right_in[3:0]),
		.top_in(),  
		.bottom_in(sb_1_sb_0), 
		.left_out(), 
		.right_out(right_out[3:0]), 
		.top_out(), 
		.bottom_out(sb_0_sb_1), 
		.left_clb_in(), 
		.right_clb_in(right_sb_in[0]), 
		.scan_in(conn_scan_in), 
		.scan_out(conn_scan_conn_0), 
		.scan_en(conn_scan_en)
	);

	//Left column
	connection_block #(CHANNEL_ONEWAY_WIDTH) inst_cb_0(
		.scan_clk(scan_clk), 
		.tracks_0(sb_1_sb_0), 
		.tracks_1(sb_0_sb_1), 
		.out_0(fpga_out[0]), 
		.out_1(right_clb_in[0]), 
		.scan_in(conn_scan_conn_0), 
		.scan_out(conn_scan_conn_1), 
		.scan_en(conn_scan_en)
	);

    wire [3:0] dummy_leftin_sb_1;
    assign dummy_leftin_sb_1[1:0] = 3'b00;
    assign dummy_leftin_sb_1[2] = fpga_in[1];
    assign dummy_leftin_sb_1[3] = fpga_in[0];

	switch_block #(CHANNEL_ONEWAY_WIDTH) inst_sb_1(
		.scan_clk(scan_clk), 
		.left_in(dummy_leftin_sb_1), 
		.right_in(right_in[7:4]), 
		.top_in(sb_0_sb_1), 
		.bottom_in(sb_2_sb_1), 
		.left_out(), 
		.right_out(right_out[7:4]), 
		.top_out(sb_1_sb_0), 
		.bottom_out(sb_1_sb_2), 
		.left_clb_in(), 
		.right_clb_in(right_sb_in[1]), 
		.scan_in(conn_scan_conn_1), 
		.scan_out(conn_scan_conn_2), 
		.scan_en(conn_scan_en)
	);

	connection_block #(CHANNEL_ONEWAY_WIDTH) inst_cb_1(
		.scan_clk(scan_clk), 
		.tracks_0(sb_2_sb_1), 
		.tracks_1(sb_1_sb_2), 
		.out_0(fpga_out[1]), 
		.out_1(right_clb_in[1]), 
		.scan_in(conn_scan_conn_2), 
		.scan_out(conn_scan_conn_3), 
		.scan_en(conn_scan_en)
	);

    wire [3:0] dummy_leftin_sb_2;
    assign dummy_leftin_sb_2[1:0] = 3'b00;
    assign dummy_leftin_sb_2[2] = fpga_in[2];
    assign dummy_leftin_sb_2[3] = fpga_in[1];

    switch_block #(CHANNEL_ONEWAY_WIDTH) inst_sb_2(
		.scan_clk(scan_clk), 
		.left_in(dummy_leftin_sb_2), 
		.right_in(right_in[11:8]),
		.top_in(sb_1_sb_2),  
		.bottom_in(sb_3_sb_2), 
		.left_out(), 
		.right_out(right_out[11:8]), 
		.top_out(sb_2_sb_1), 
		.bottom_out(sb_2_sb_3), 
		.left_clb_in(), 
		.right_clb_in(right_sb_in[2]), 
		.scan_in(conn_scan_conn_3), 
		.scan_out(conn_scan_conn_4), 
		.scan_en(conn_scan_en)
	);

	connection_block #(CHANNEL_ONEWAY_WIDTH) inst_cb_2(
		.scan_clk(scan_clk), 
		.tracks_0(sb_3_sb_2), 
		.tracks_1(sb_2_sb_3), 
		.out_0(fpga_out[2]), 
		.out_1(right_clb_in[2]), 
		.scan_in(conn_scan_conn_4), 
		.scan_out(conn_scan_conn_5), 
		.scan_en(conn_scan_en)
	);

    wire [3:0] dummy_leftin_sb_3;
    assign dummy_leftin_sb_3[1:0] = 3'b00;
    assign dummy_leftin_sb_3[2] = fpga_in[3];
    assign dummy_leftin_sb_3[3] = fpga_in[2];

	switch_block #(CHANNEL_ONEWAY_WIDTH) inst_sb_3(
		.scan_clk(scan_clk), 
		.left_in(dummy_leftin_sb_3), 
		.right_in(right_in[15:12]), 
		.top_in(sb_2_sb_3), 
		.bottom_in(sb_4_sb_3), 
		.left_out(), 
		.right_out(right_out[15:12]), 
		.top_out(sb_3_sb_2), 
		.bottom_out(sb_3_sb_4), 
		.left_clb_in(), 
		.right_clb_in(right_sb_in[3]), 
		.scan_in(conn_scan_conn_5), 
		.scan_out(conn_scan_conn_6), 
		.scan_en(conn_scan_en)
	);

	connection_block #(CHANNEL_ONEWAY_WIDTH) inst_cb_3(
		.scan_clk(scan_clk), 
		.tracks_0(sb_4_sb_3), 
		.tracks_1(sb_3_sb_4), 
		.out_0(fpga_out[3]), 
		.out_1(right_clb_in[3]), 
		.scan_in(conn_scan_conn_6), 
		.scan_out(conn_scan_conn_7), 
		.scan_en(conn_scan_en)
	);

	wire [3:0] dummy_leftin_sb_4;
    assign dummy_leftin_sb_4[1:0] = 3'b00;
    assign dummy_leftin_sb_4[2] = fpga_in[4];
    assign dummy_leftin_sb_4[3] = fpga_in[3];

	switch_block #(CHANNEL_ONEWAY_WIDTH) inst_sb_4(
		.scan_clk(scan_clk), 
		.left_in(dummy_leftin_sb_4), 
		.right_in(right_in[19:16]), 
		.top_in(sb_3_sb_4), 
		.bottom_in(sb_5_sb_4), 
		.left_out(), 
		.right_out(right_out[19:16]), 
		.top_out(sb_4_sb_3), 
		.bottom_out(sb_4_sb_5), 
		.left_clb_in(), 
		.right_clb_in(right_sb_in[4]), 
		.scan_in(conn_scan_conn_7), 
		.scan_out(conn_scan_conn_8), 
		.scan_en(conn_scan_en)
	);

	connection_block #(CHANNEL_ONEWAY_WIDTH) inst_cb_4(
		.scan_clk(scan_clk), 
		.tracks_0(sb_5_sb_4), 
		.tracks_1(sb_4_sb_5), 
		.out_0(fpga_out[4]), 
		.out_1(right_clb_in[4]), 
		.scan_in(conn_scan_conn_8), 
		.scan_out(conn_scan_conn_9), 
		.scan_en(conn_scan_en)
	);

	wire [3:0] dummy_leftin_sb_5;
    assign dummy_leftin_sb_5[1:0] = 3'b00;
    assign dummy_leftin_sb_5[2] = fpga_in[5];
    assign dummy_leftin_sb_5[3] = fpga_in[4];

	switch_block #(CHANNEL_ONEWAY_WIDTH) inst_sb_5(
		.scan_clk(scan_clk), 
		.left_in(dummy_leftin_sb_5), 
		.right_in(right_in[23:20]), 
		.top_in(sb_4_sb_5), 
		.bottom_in(sb_6_sb_5), 
		.left_out(), 
		.right_out(right_out[23:20]), 
		.top_out(sb_5_sb_4), 
		.bottom_out(sb_5_sb_6), 
		.left_clb_in(), 
		.right_clb_in(right_sb_in[5]), 
		.scan_in(conn_scan_conn_9), 
		.scan_out(conn_scan_conn_10), 
		.scan_en(conn_scan_en)
	);

	connection_block #(CHANNEL_ONEWAY_WIDTH) inst_cb_5(
		.scan_clk(scan_clk), 
		.tracks_0(sb_6_sb_5), 
		.tracks_1(sb_5_sb_6), 
		.out_0(fpga_out[5]), 
		.out_1(right_clb_in[5]), 
		.scan_in(conn_scan_conn_10), 
		.scan_out(conn_scan_conn_11), 
		.scan_en(conn_scan_en)
	);

	wire [3:0] dummy_leftin_sb_6;
    assign dummy_leftin_sb_6[1:0] = 3'b00;
    assign dummy_leftin_sb_6[2] = fpga_in[6];
    assign dummy_leftin_sb_6[3] = fpga_in[5];

	switch_block #(CHANNEL_ONEWAY_WIDTH) inst_sb_6(
		.scan_clk(scan_clk), 
		.left_in(dummy_leftin_sb_6), 
		.right_in(right_in[27:24]), 
		.top_in(sb_5_sb_6), 
		.bottom_in(sb_7_sb_6), 
		.left_out(), 
		.right_out(right_out[27:24]), 
		.top_out(sb_6_sb_5), 
		.bottom_out(sb_6_sb_7), 
		.left_clb_in(), 
		.right_clb_in(right_sb_in[6]), 
		.scan_in(conn_scan_conn_11), 
		.scan_out(conn_scan_conn_12), 
		.scan_en(conn_scan_en)
	);

	connection_block #(CHANNEL_ONEWAY_WIDTH) inst_cb_6(
		.scan_clk(scan_clk), 
		.tracks_0(sb_7_sb_6), 
		.tracks_1(sb_6_sb_7), 
		.out_0(fpga_out[6]), 
		.out_1(right_clb_in[6]), 
		.scan_in(conn_scan_conn_12), 
		.scan_out(conn_scan_conn_13), 
		.scan_en(conn_scan_en)
	);

	wire [3:0] dummy_leftin_sb_7;
    assign dummy_leftin_sb_7[1:0] = 3'b00;
    assign dummy_leftin_sb_7[2] = fpga_in[7];
    assign dummy_leftin_sb_7[3] = fpga_in[6];

	switch_block #(CHANNEL_ONEWAY_WIDTH) inst_sb_7(
		.scan_clk(scan_clk), 
		.left_in(dummy_leftin_sb_7), 
		.right_in(right_in[31:28]), 
		.top_in(sb_6_sb_7), 
		.bottom_in(sb_8_sb_7), 
		.left_out(), 
		.right_out(right_out[31:28]), 
		.top_out(sb_7_sb_6), 
		.bottom_out(sb_7_sb_8), 
		.left_clb_in(), 
		.right_clb_in(right_sb_in[7]), 
		.scan_in(conn_scan_conn_13), 
		.scan_out(conn_scan_conn_14), 
		.scan_en(conn_scan_en)
	);

	connection_block #(CHANNEL_ONEWAY_WIDTH) inst_cb_7(
		.scan_clk(scan_clk), 
		.tracks_0(sb_8_sb_7), 
		.tracks_1(sb_7_sb_8), 
		.out_0(fpga_out[7]), 
		.out_1(right_clb_in[7]), 
		.scan_in(conn_scan_conn_14), 
		.scan_out(conn_scan_conn_15), 
		.scan_en(conn_scan_en)
	);

	//Bottom left corner
	wire [3:0] dummy_leftin_sb_8;
    assign dummy_leftin_sb_8[2:0] = 3'b000;
    assign dummy_leftin_sb_8[3] = fpga_in[7];
	switch_block #(CHANNEL_ONEWAY_WIDTH) inst_sb_8(
		.scan_clk(scan_clk), 
		.left_in(dummy_leftin_sb_8), 
		.right_in(sb_9_sb_8), 
		.top_in(sb_7_sb_8), 
		.bottom_in(), 
		.left_out(), 
		.right_out(sb_8_sb_9), 
		.top_out(sb_8_sb_7), 
		.bottom_out(), 
		.left_clb_in(), 
		.right_clb_in(fpga_in[8]), 
		.scan_in(conn_scan_conn_15), 
		.scan_out(conn_scan_conn_16), 
		.scan_en(conn_scan_en)
	);

	connection_block #(CHANNEL_ONEWAY_WIDTH) inst_cb_8(
		.scan_clk(scan_clk), 
		.tracks_0(sb_9_sb_8), 
		.tracks_1(sb_8_sb_9), 
		.out_0(top_clb_in[0]), 
		.out_1(fpga_out[8]), 
		.scan_in(conn_scan_conn_16), 
		.scan_out(conn_scan_conn_17), 
		.scan_en(conn_scan_en)
	);

	//Bottom row
	switch_block #(CHANNEL_ONEWAY_WIDTH) inst_sb_9(
		.scan_clk(scan_clk), 
		.left_in(sb_8_sb_9), 
		.right_in(sb_10_sb_9), 
		.top_in(top_in[3:0]), 
		.bottom_in(), 
		.left_out(sb_9_sb_8), 
		.right_out(sb_9_sb_10), 
		.top_out(top_out[3:0]), 
		.bottom_out(), 
		.left_clb_in(fpga_in[8]), 
		.right_clb_in(fpga_in[9]), 
		.scan_in(conn_scan_conn_17), 
		.scan_out(conn_scan_conn_18), 
		.scan_en(conn_scan_en)
	);

	connection_block #(CHANNEL_ONEWAY_WIDTH) inst_cb_9(
		.scan_clk(scan_clk), 
		.tracks_0(sb_10_sb_9), 
		.tracks_1(sb_9_sb_10), 
		.out_0(top_clb_in[1]), 
		.out_1(fpga_out[9]), 
		.scan_in(conn_scan_conn_18), 
		.scan_out(conn_scan_conn_19), 
		.scan_en(conn_scan_en)
	);

	switch_block #(CHANNEL_ONEWAY_WIDTH) inst_sb_10(
		.scan_clk(scan_clk), 
		.left_in(sb_9_sb_10), 
		.right_in(sb_11_sb_10), 
		.top_in(top_in[7:4]), 
		.bottom_in(), 
		.left_out(sb_10_sb_9), 
		.right_out(sb_10_sb_11), 
		.top_out(top_out[7:4]), 
		.bottom_out(), 
		.left_clb_in(fpga_in[9]), 
		.right_clb_in(), 
		.scan_in(conn_scan_conn_19), 
		.scan_out(conn_scan_conn_20), 
		.scan_en(conn_scan_en)
	);
	
	connection_block #(CHANNEL_ONEWAY_WIDTH) inst_cb_10(
		.scan_clk(scan_clk), 
		.tracks_0(sb_11_sb_10), 
		.tracks_1(sb_10_sb_11), 
		.out_0(top_clb_in[2]), 
		.out_1(), 
		.scan_in(conn_scan_conn_20), 
		.scan_out(conn_scan_conn_21), 
		.scan_en(conn_scan_en)
	);

	switch_block #(CHANNEL_ONEWAY_WIDTH) inst_sb_11(
		.scan_clk(scan_clk), 
		.left_in(sb_10_sb_11), 
		.right_in(sb_12_sb_11), 
		.top_in(top_in[11:8]), 
		.bottom_in(), 
		.left_out(sb_11_sb_10), 
		.right_out(sb_11_sb_12), 
		.top_out(top_out[11:8]), 
		.bottom_out(), 
		.left_clb_in(), 
		.right_clb_in(), 
		.scan_in(conn_scan_conn_21), 
		.scan_out(conn_scan_conn_22), 
		.scan_en(conn_scan_en)
	);
	
	connection_block #(CHANNEL_ONEWAY_WIDTH) inst_cb_11(
		.scan_clk(scan_clk), 
		.tracks_0(sb_12_sb_11), 
		.tracks_1(sb_11_sb_12), 
		.out_0(top_clb_in[3]), 
		.out_1(), 
		.scan_in(conn_scan_conn_22), 
		.scan_out(conn_scan_conn_23), 
		.scan_en(conn_scan_en)
	);

	switch_block #(CHANNEL_ONEWAY_WIDTH) inst_sb_12(
		.scan_clk(scan_clk), 
		.left_in(sb_11_sb_12), 
		.right_in(sb_13_sb_12), 
		.top_in(top_in[15:12]), 
		.bottom_in(), 
		.left_out(sb_12_sb_11), 
		.right_out(sb_12_sb_13), 
		.top_out(top_out[15:12]), 
		.bottom_out(), 
		.left_clb_in(), 
		.right_clb_in(), 
		.scan_in(conn_scan_conn_23), 
		.scan_out(conn_scan_conn_24), 
		.scan_en(conn_scan_en)
	);
	
	connection_block #(CHANNEL_ONEWAY_WIDTH) inst_cb_12(
		.scan_clk(scan_clk), 
		.tracks_0(sb_13_sb_12), 
		.tracks_1(sb_12_sb_13), 
		.out_0(top_clb_in[4]), 
		.out_1(), 
		.scan_in(conn_scan_conn_24), 
		.scan_out(conn_scan_conn_25), 
		.scan_en(conn_scan_en)
	);

	switch_block #(CHANNEL_ONEWAY_WIDTH) inst_sb_13(
		.scan_clk(scan_clk), 
		.left_in(sb_12_sb_13), 
		.right_in(sb_14_sb_13), 
		.top_in(top_in[19:16]), 
		.bottom_in(), 
		.left_out(sb_13_sb_12), 
		.right_out(sb_13_sb_14), 
		.top_out(top_out[19:16]), 
		.bottom_out(), 
		.left_clb_in(), 
		.right_clb_in(), 
		.scan_in(conn_scan_conn_25), 
		.scan_out(conn_scan_conn_26), 
		.scan_en(conn_scan_en)
	);
	
	connection_block #(CHANNEL_ONEWAY_WIDTH) inst_cb_13(
		.scan_clk(scan_clk), 
		.tracks_0(sb_14_sb_13), 
		.tracks_1(sb_13_sb_14), 
		.out_0(top_clb_in[5]), 
		.out_1(), 
		.scan_in(conn_scan_conn_26), 
		.scan_out(conn_scan_conn_27), 
		.scan_en(conn_scan_en)
	);

	switch_block #(CHANNEL_ONEWAY_WIDTH) inst_sb_14(
		.scan_clk(scan_clk), 
		.left_in(sb_13_sb_14), 
		.right_in(sb_15_sb_14), 
		.top_in(top_in[23:20]), 
		.bottom_in(), 
		.left_out(sb_14_sb_13), 
		.right_out(sb_14_sb_15), 
		.top_out(top_out[23:20]), 
		.bottom_out(), 
		.left_clb_in(), 
		.right_clb_in(), 
		.scan_in(conn_scan_conn_27), 
		.scan_out(conn_scan_conn_28), 
		.scan_en(conn_scan_en)
	);
	
	connection_block #(CHANNEL_ONEWAY_WIDTH) inst_cb_14(
		.scan_clk(scan_clk), 
		.tracks_0(sb_15_sb_14), 
		.tracks_1(sb_14_sb_15), 
		.out_0(top_clb_in[6]), 
		.out_1(), 
		.scan_in(conn_scan_conn_28), 
		.scan_out(conn_scan_conn_29), 
		.scan_en(conn_scan_en)
	);

	switch_block #(CHANNEL_ONEWAY_WIDTH) inst_sb_15(
		.scan_clk(scan_clk), 
		.left_in(sb_14_sb_15), 
		.right_in(sb_16_sb_15), 
		.top_in(top_in[27:24]), 
		.bottom_in(), 
		.left_out(sb_15_sb_14), 
		.right_out(sb_15_sb_16), 
		.top_out(top_out[27:24]), 
		.bottom_out(), 
		.left_clb_in(), 
		.right_clb_in(), 
		.scan_in(conn_scan_conn_29), 
		.scan_out(conn_scan_conn_30), 
		.scan_en(conn_scan_en)
	);
	
	connection_block #(CHANNEL_ONEWAY_WIDTH) inst_cb_15(
		.scan_clk(scan_clk), 
		.tracks_0(sb_16_sb_15), 
		.tracks_1(sb_15_sb_16), 
		.out_0(top_clb_in[7]), 
		.out_1(), 
		.scan_in(conn_scan_conn_30), 
		.scan_out(conn_scan_conn_31), 
		.scan_en(conn_scan_en)
	);

	//Bottom right corner 	
	switch_block #(CHANNEL_ONEWAY_WIDTH) inst_sb_16(
		.scan_clk(scan_clk), 
		.left_in(sb_15_sb_16), 
		.right_in(), 
		.top_in(top_in[31:28]), 
		.bottom_in(), 
		.left_out(sb_16_sb_15), 
		.right_out(), 
		.top_out(top_out[31:28]), 
		.bottom_out(), 
		.left_clb_in(), 
		.right_clb_in(), 
		.scan_in(conn_scan_conn_31), 
		.scan_out(conn_scan_out), 
		.scan_en(conn_scan_en)
	);
    
endmodule