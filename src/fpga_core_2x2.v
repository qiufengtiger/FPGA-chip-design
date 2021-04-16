`include "tile.v"
`include "clb.v"
`include "switch_block.v"
`include "connection_block.v"
`include "basic-gates.v"
`include "shift_reg.v"
`include "sram.v"

// 2 * 2 fpga
// built for primary fpga functional test because bitstream generator is pending
// bitstream used in testbench is hand-translated from VTR result
// fpga structure:
//          clockwised order, same as CLB port ordering in VTR
//        ------------------------------\
// 			                            |
//		 SB4 \    	                    |
// io7 - CB3 - tile0 - tile1            |
//		 SB3	|	    |				v
// io6 - CB2 - tile3 - tile2 - io3
//		  |	    |	    |	\
//		 SB2 - CB1 SB1 CB0 - SB0
//			    |       |
// 			   io5     io4
// need extra CB & SB on the left and bottom of the FPGA, see tile.v for structure in tile
module fpga_core_2x2(clk, reset, scan_clk, fpga_in, fpga_out, clb_scan_in, clb_scan_out, clb_scan_en, conn_scan_in, conn_scan_out, conn_scan_en);
	//  how many tile in a column / row
	parameter FPGA_WIDTH = 2;
	parameter CHANNEL_ONEWAY_WIDTH = 4;
	parameter CLB_BLE_NUM = 1;
	parameter CONN_SEL_WIDTH = 3;

	input [3:0] fpga_in;
	output [3:0] fpga_out;
	input clb_scan_in, clb_scan_en, conn_scan_in, conn_scan_en, clk, scan_clk, reset;
	output clb_scan_out, conn_scan_out;

	// clb_scanchain: scan_in -> tile0 -> tile1 -> tile2 -> tile3 -> scan_out
	// conn_scanchain: scan_in -> SB0 -> CB0 -> SB1 -> CB1 -> SB2 -> CB2 -> SB3 -> CB3 -> SB4 -> tile0 -> tile1 -> tile2 -> tile3 -> scan_out
	wire clb_scan_conn_0, clb_scan_conn_1, clb_scan_conn_2;
	wire conn_scan_conn_0, conn_scan_conn_1, conn_scan_conn_2, conn_scan_conn_3, conn_scan_conn_4, conn_scan_conn_5, conn_scan_conn_6;
	wire conn_scan_conn_7, conn_scan_conn_8, conn_scan_conn_9, conn_scan_conn_10, conn_scan_conn_11;

	// <origin_block>_<id>_<dest_block>_<id>
	wire [CHANNEL_ONEWAY_WIDTH-1:0] sb_0_tile_2, sb_1_tile_3, sb_3_tile_3, sb_4_tile_0;
	wire [CHANNEL_ONEWAY_WIDTH-1:0] tile_2_sb_0, tile_3_sb_1, tile_3_sb_3, tile_0_sb_4;
	wire [CHANNEL_ONEWAY_WIDTH-1:0] sb_0_sb_1, sb_1_sb_2, sb_2_sb_3, sb_3_sb_4;
    wire [CHANNEL_ONEWAY_WIDTH-1:0] sb_1_sb_0, sb_2_sb_1, sb_3_sb_2, sb_4_sb_3;
    wire [CHANNEL_ONEWAY_WIDTH-1:0] tile_0_tile_1, tile_1_tile_0, tile_1_tile_2, tile_2_tile_1, tile_2_tile_3, tile_3_tile_2, tile_0_tile_3, tile_3_tile_0;

	wire cb_0_tile_2, cb_1_tile_3, cb_2_tile_3, cb_3_tile_0; 
	wire io_0_tile_0, io_1_tile_1, io_2_tile_1, io_3_tile_2; 
    
    wire clb_out0, clb_out1, clb_out2, clb_out3;

	switch_block #(CHANNEL_ONEWAY_WIDTH) inst_sb_0(
		.scan_clk(scan_clk), 
		.left_in(sb_1_sb_0), 
		.right_in(),
		.top_in(tile_2_sb_0),  
		.bottom_in(), 
		.left_out(sb_0_sb_1), 
		.right_out(), 
		.top_out(sb_0_tile_2), 
		.bottom_out(), 
		.left_clb_in(fpga_in[0]), 
		.right_clb_in(), 
		.scan_in(conn_scan_in), 
		.scan_out(conn_scan_conn_0), 
		.scan_en(conn_scan_en)
	);

	connection_block #(CHANNEL_ONEWAY_WIDTH) inst_cb_0(
		.scan_clk(scan_clk), 
		.tracks_0(sb_0_sb_1), 
		.tracks_1(sb_1_sb_0), 
		.out_0(cb_0_tile_2), 
		.out_1(fpga_out[0]), 
		.scan_in(conn_scan_conn_0), 
		.scan_out(conn_scan_conn_1), 
		.scan_en(conn_scan_en)
	);

	switch_block #(CHANNEL_ONEWAY_WIDTH) inst_sb_1(
		.scan_clk(scan_clk), 
		.left_in(sb_2_sb_1), 
		.right_in(sb_0_sb_1), 
		.top_in(tile_3_sb_1), 
		.bottom_in(), 
		.left_out(sb_1_sb_2), 
		.right_out(sb_1_sb_0), 
		.top_out(sb_1_tile_3), 
		.bottom_out(), 
		.left_clb_in(fpga_in[1]), 
		.right_clb_in(fpga_in[0]), 
		.scan_in(conn_scan_conn_1), 
		.scan_out(conn_scan_conn_2), 
		.scan_en(conn_scan_en)
	);

	connection_block #(CHANNEL_ONEWAY_WIDTH) inst_cb_1(
		.scan_clk(scan_clk), 
		.tracks_0(sb_1_sb_2), 
		.tracks_1(sb_2_sb_1), 
		.out_0(cb_1_tile_3), 
		.out_1(fpga_out[1]), 
		.scan_in(conn_scan_conn_2), 
		.scan_out(conn_scan_conn_3), 
		.scan_en(conn_scan_en)
	);

    wire [3:0] dummy_leftin_sb_2;
    assign dummy_leftin_sb_2[2:0] = 3'b000;
    assign dummy_leftin_sb_2[3] = fpga_in[2];

	switch_block #(CHANNEL_ONEWAY_WIDTH) inst_sb_2(
		.scan_clk(scan_clk), 
		.left_in(dummy_leftin_sb_2), 
		.right_in(sb_1_sb_2), 
		.top_in(sb_3_sb_2), 
		.bottom_in(), 
		.left_out(), 
		.right_out(sb_2_sb_1), 
		.top_out(sb_2_sb_3), 
		.bottom_out(), 
		.left_clb_in(), 
		.right_clb_in(fpga_in[1]), 
		.scan_in(conn_scan_conn_3), 
		.scan_out(conn_scan_conn_4), 
		.scan_en(conn_scan_en)
	);

	connection_block #(CHANNEL_ONEWAY_WIDTH) inst_cb_2(
		.scan_clk(scan_clk), 
		.tracks_0(sb_2_sb_3), 
		.tracks_1(sb_3_sb_2), 
		.out_0(fpga_out[2]), 
		.out_1(cb_2_tile_3), 
		.scan_in(conn_scan_conn_4), 
		.scan_out(conn_scan_conn_5), 
		.scan_en(conn_scan_en)
	);

    wire [3:0] dummy_leftin_sb_3;
    assign dummy_leftin_sb_3[1:0] = 3'b00;
    assign dummy_leftin_sb_3[2] = fpga_in[2];
    assign dummy_leftin_sb_3[3] = fpga_in[3];

    // fix 1: top_in, bottom_in, top_out
	switch_block #(CHANNEL_ONEWAY_WIDTH) inst_sb_3(
		.scan_clk(scan_clk), 
		.left_in(dummy_leftin_sb_3), 
		.right_in(tile_3_sb_3), 
		.top_in(sb_4_sb_3), 
		.bottom_in(sb_2_sb_3), 
		.left_out(), 
		.right_out(sb_3_tile_3), 
		.top_out(sb_3_sb_4), 
		.bottom_out(sb_3_sb_2), 
		.left_clb_in(), 
		.right_clb_in(clb_out3), 
		.scan_in(conn_scan_conn_5), 
		.scan_out(conn_scan_conn_6), 
		.scan_en(conn_scan_en)
	);

	connection_block #(CHANNEL_ONEWAY_WIDTH) inst_cb_3(
		.scan_clk(scan_clk), 
		.tracks_0(sb_3_sb_4), 
		.tracks_1(sb_4_sb_3), 
		.out_0(fpga_out[3]), 
		.out_1(cb_3_tile_0), 
		.scan_in(conn_scan_conn_6), 
		.scan_out(conn_scan_conn_7), 
		.scan_en(conn_scan_en)
	);

    wire [3:0] dummy_leftin_sb_4;
    assign dummy_leftin_sb_4[1:0] = 2'b00;
    assign dummy_leftin_sb_4[2] = fpga_in[3];
    assign dummy_leftin_sb_4[3] = 1'b0;

	switch_block #(CHANNEL_ONEWAY_WIDTH) inst_sb_4(
		.scan_clk(scan_clk), 
		.left_in(dummy_leftin_sb_4), 
		.right_in(tile_0_sb_4), 
		.top_in(), 
		.bottom_in(sb_3_sb_4), 
		.left_out(), 
		.right_out(sb_4_tile_0), 
		.top_out(), 
		.bottom_out(sb_4_sb_3), 
		.left_clb_in(), 
		.right_clb_in(clb_out0), 
		.scan_in(conn_scan_conn_7), 
		.scan_out(conn_scan_conn_8), 
		.scan_en(conn_scan_en)
	);

    wire left_clb_in_tile_1;
    wire bottom_clb_in_tile_0;

	tile #(CHANNEL_ONEWAY_WIDTH, CLB_BLE_NUM, CONN_SEL_WIDTH) inst_tile_0(
		.clk(clk),
        .scan_clk(scan_clk),
		.left_in(sb_4_tile_0),
		.right_in(tile_1_tile_0),
		.top_in(),
		.bottom_in(tile_3_tile_0),
		.left_out(tile_0_sb_4),
		.right_out(tile_0_tile_1),
		.top_out(),
		.bottom_out(tile_0_tile_3),
		.left_clb_out(clb_out0),
		.left_clb_in(cb_3_tile_0),
		.right_sb_in(clb_out1),
		.right_cb_out(left_clb_in_tile_1),
		.top_cb_out(),
		.bottom_clb_in(bottom_clb_in_tile_0),
		.clb_scan_in(clb_scan_in), 
		.clb_scan_out(clb_scan_conn_0), 
		.clb_scan_en(clb_scan_en), 
		.conn_scan_in(conn_scan_conn_8), 
		.conn_scan_out(conn_scan_conn_9), 
		.conn_scan_en(conn_scan_en),
		.test_out_x4(),
		.reset(reset)
	);

    wire bottom_clb_in_tile_1;

	tile #(CHANNEL_ONEWAY_WIDTH, CLB_BLE_NUM, CONN_SEL_WIDTH) inst_tile_1(
		.clk(clk),
		.scan_clk(scan_clk),
		.left_in(tile_0_tile_1),
		.right_in(),
		.top_in(),
		.bottom_in(tile_2_tile_1),
		.left_out(tile_1_tile_0),
		.right_out(),
		.top_out(),
		.bottom_out(tile_1_tile_2),
		.left_clb_out(clb_out1),
		.left_clb_in(left_clb_in_tile_1),
		.right_sb_in(),
		.right_cb_out(),
		.top_cb_out(),
		.bottom_clb_in(bottom_clb_in_tile_1),
		.clb_scan_in(clb_scan_conn_0), 
		.clb_scan_out(clb_scan_conn_1), 
		.clb_scan_en(clb_scan_en), 
		.conn_scan_in(conn_scan_conn_9), 
		.conn_scan_out(conn_scan_conn_10), 
		.conn_scan_en(conn_scan_en),
		.test_out_x4(),
		.reset(reset)
	);
    wire left_clb_in_tile_2;

	tile #(CHANNEL_ONEWAY_WIDTH, CLB_BLE_NUM, CONN_SEL_WIDTH) inst_tile_2(
		.clk(clk),
		.scan_clk(scan_clk),
		.left_in(tile_3_tile_2),
		.right_in(),
		.top_in(tile_1_tile_2),
		.bottom_in(sb_0_tile_2),
		.left_out(tile_2_tile_3),
		.right_out(),
		.top_out(tile_2_tile_1),
		.bottom_out(tile_2_sb_0),
		.left_clb_out(clb_out2),
		.left_clb_in(left_clb_in_tile_2),
		.right_sb_in(),
		.right_cb_out(),
		.top_cb_out(bottom_clb_in_tile_1),
		.bottom_clb_in(cb_0_tile_2),
		.clb_scan_in(clb_scan_conn_1), 
		.clb_scan_out(clb_scan_conn_2), 
		.clb_scan_en(clb_scan_en), 
		.conn_scan_in(conn_scan_conn_10), 
		.conn_scan_out(conn_scan_conn_11), 
		.conn_scan_en(conn_scan_en),
		.test_out_x4(),
		.reset(reset)
	);

	tile #(CHANNEL_ONEWAY_WIDTH, CLB_BLE_NUM, CONN_SEL_WIDTH) inst_tile_3(
		.clk(clk),
		.scan_clk(scan_clk),
		.left_in(sb_3_tile_3),
		.right_in(tile_2_tile_3),
		.top_in(tile_0_tile_3),
		.bottom_in(sb_1_tile_3),
		.left_out(tile_3_sb_3),
		.right_out(tile_3_tile_2),
		.top_out(tile_3_tile_0),
		.bottom_out(tile_3_sb_1),
		.left_clb_out(clb_out3),
		.left_clb_in(cb_2_tile_3),
		.right_sb_in(clb_out2),
		.right_cb_out(left_clb_in_tile_2),
		.top_cb_out(bottom_clb_in_tile_0),
		.bottom_clb_in(cb_1_tile_3),
		.clb_scan_in(clb_scan_conn_2), 
		.clb_scan_out(clb_scan_out), 
		.clb_scan_en(clb_scan_en), 
		.conn_scan_in(conn_scan_conn_11), 
		.conn_scan_out(conn_scan_out), 
		.conn_scan_en(conn_scan_en),
		.test_out_x4(),
		.reset(reset)
	);

endmodule