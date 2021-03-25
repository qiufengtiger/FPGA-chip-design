`include "tile.v"

// 2 * 2 fpga
// built for primary fpga functional test
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
module fpga_top(clk, fpga_io, clb_scan_in, clb_scan_out, clb_scan_en, conn_scan_in, conn_scan_out, conn_scan_en);
	//  how many tile in a column / row
	parameter FPGA_WIDTH = 2;
	parameter CHANNEL_ONEWAY_WIDTH = 4;
	parameter CLB_BLE_NUM = 1;
	parameter CONN_SEL_WIDTH = 3;

	inout [FPGA_WIDTH*4-1:0] fpga_io;
	input clb_scan_in, clb_scan_en, conn_scan_in, conn_scan_en;
	output clb_scan_out, conn_scan_out;

	// clb_scanchain: scan_in -> tile0 -> tile1 -> tile2 -> tile3 -> scan_out
	// conn_scanchain: scan_in -> SB0 -> CB0 -> SB1 -> CB1 -> SB2 -> CB2 -> SB3 -> CB3 -> SB4 -> tile0 -> tile1 -> tile2 -> tile3 -> scan_out
	wire clb_scan_conn_0, clb_scan_conn_1, clb_scan_conn_2;
	wire conn_scan_conn_0, conn_scan_conn_1, conn_scan_conn_2, conn_scan_conn_3, conn_scan_conn_4, conn_scan_conn_5, conn_scan_conn_6;
	wire conn_scan_conn_7, conn_scan_conn_8, conn_scan_conn_9, conn_scan_conn_10, conn_scan_conn_11;

	// <origin_block>_<id>_<dest_block>_<id>
	wire [CHANNEL_ONEWAY_WIDTH-1:0] sb_0_tile_2, sb_1_tile_3, sb_3_tile_3, sb_4_tile_0;
	wire [CHANNEL_ONEWAY_WIDTH-1:0] tile_2_sb_0, tile_3_sb_1, tile_3_sb_3, tile_0_sb_4;
	wire [CHANNEL_ONEWAY_WIDTH-1:0] sb_0_cb_0, sb_1_cb_0, sb_1_cb_1, sb_2_cb_1, sb_2_cb_2, sb_3_cb_2, sb_3_cb_3, sb_4_cb_3;
	wire [CHANNEL_ONEWAY_WIDTH-1:0] cb_0_sb_0, cb_0_sb_1, cb_1_sb_1, cb_1_sb_2, cb_2_sb_2, cb_2_sb_3, cb_3_sb_3, cb_3_sb_4;
	wire cb_0_tile2, cb_1_tile3, cb_2_tile3, cb_3_tile0; 
	wire io_0_tile_0, io_1_tile_1, io_2_tile_1, io_3_tile_2; 

	switch_block #(CHANNEL_ONEWAY_WIDTH) inst_sb_0(
		.clk(clk), 
		.left_in(), 
		.right_in(), 
		.top_in(), 
		.bottom_in(), 
		.left_out(), 
		.right_out(), 
		.top_out(), 
		.bottom_out(), 
		.left_clb_in(), 
		.right_clb_in(), 
		.scan_in(conn_scan_in), 
		.scan_out(conn_scan_conn_0), 
		.scan_en(conn_scan_en)
	);

	connection_block #(CHANNEL_ONEWAY_WIDTH) inst_cb_0(
		.clk(clk), 
		.tracks_0(), 
		.tracks_1(), 
		.out_0(), 
		.out_1(), 
		.scan_in(conn_scan_conn_0), 
		.scan_out(conn_scan_conn_1), 
		.scan_en(conn_scan_en)
	);

	switch_block #(CHANNEL_ONEWAY_WIDTH) inst_sb_1(
		.clk(clk), 
		.left_in(), 
		.right_in(), 
		.top_in(), 
		.bottom_in(), 
		.left_out(), 
		.right_out(), 
		.top_out(), 
		.bottom_out(), 
		.left_clb_in(), 
		.right_clb_in(), 
		.scan_in(conn_scan_conn_1), 
		.scan_out(conn_scan_conn_2), 
		.scan_en(conn_scan_en)
	);

	connection_block #(CHANNEL_ONEWAY_WIDTH) inst_cb_1(
		.clk(clk), 
		.tracks_0(), 
		.tracks_1(), 
		.out_0(), 
		.out_1(), 
		.scan_in(conn_scan_conn_2), 
		.scan_out(conn_scan_conn_3), 
		.scan_en(conn_scan_en)
	);

	switch_block #(CHANNEL_ONEWAY_WIDTH) inst_sb_2(
		.clk(clk), 
		.left_in(), 
		.right_in(), 
		.top_in(), 
		.bottom_in(), 
		.left_out(), 
		.right_out(), 
		.top_out(), 
		.bottom_out(), 
		.left_clb_in(), 
		.right_clb_in(), 
		.scan_in(conn_scan_conn_3), 
		.scan_out(conn_scan_conn_4), 
		.scan_en(conn_scan_en)
	);

	connection_block #(CHANNEL_ONEWAY_WIDTH) inst_cb_2(
		.clk(clk), 
		.tracks_0(), 
		.tracks_1(), 
		.out_0(), 
		.out_1(), 
		.scan_in(conn_scan_conn_4), 
		.scan_out(conn_scan_conn_5), 
		.scan_en(conn_scan_en)
	);

	switch_block #(CHANNEL_ONEWAY_WIDTH) inst_sb_3(
		.clk(clk), 
		.left_in(), 
		.right_in(), 
		.top_in(), 
		.bottom_in(), 
		.left_out(), 
		.right_out(), 
		.top_out(), 
		.bottom_out(), 
		.left_clb_in(), 
		.right_clb_in(), 
		.scan_in(conn_scan_conn_5), 
		.scan_out(conn_scan_conn_6), 
		.scan_en(conn_scan_en)
	);

	connection_block #(CHANNEL_ONEWAY_WIDTH) inst_cb_3(
		.clk(clk), 
		.tracks_0(), 
		.tracks_1(), 
		.out_0(), 
		.out_1(), 
		.scan_in(conn_scan_conn_6), 
		.scan_out(conn_scan_conn_7), 
		.scan_en(conn_scan_en)
	);

	switch_block #(CHANNEL_ONEWAY_WIDTH) inst_sb_4(
		.clk(clk), 
		.left_in(), 
		.right_in(), 
		.top_in(), 
		.bottom_in(), 
		.left_out(), 
		.right_out(), 
		.top_out(), 
		.bottom_out(), 
		.left_clb_in(), 
		.right_clb_in(), 
		.scan_in(conn_scan_conn_7), 
		.scan_out(conn_scan_conn_8), 
		.scan_en(conn_scan_en)
	);

	tile #(CHANNEL_ONEWAY_WIDTH, CLB_BLE_NUM, CONN_SEL_WIDTH) inst_tile_0(
		.clk(clk),
		.left_in(),
		.right_in(),
		.top_in(),
		.bottom_in(),
		.left_out(),
		.right_out(),
		.top_out(),
		.bottom_out(),
		.left_clb_out(),
		.left_clb_in(),
		.right_sb_in(),
		.right_cb_out(),
		.tio_cb_out(),
		.bottom_clb_in(),
		.clb_scan_in(clb_scan_in), 
		.clb_scan_out(clb_scan_conn_0), 
		.clb_scan_en(clb_scan_en), 
		.conn_scan_in(conn_scan_conn_8), 
		.conn_scan_out(conn_scan_conn_9), 
		.conn_scan_en(conn_scan_en),
		.test_out_x4()
	);

	tile #(CHANNEL_ONEWAY_WIDTH, CLB_BLE_NUM, CONN_SEL_WIDTH) inst_tile_1(
		.clk(clk),
		.left_in(),
		.right_in(),
		.top_in(),
		.bottom_in(),
		.left_out(),
		.right_out(),
		.top_out(),
		.bottom_out(),
		.left_clb_out(),
		.left_clb_in(),
		.right_sb_in(),
		.right_cb_out(),
		.tio_cb_out(),
		.bottom_clb_in(),
		.clb_scan_in(clb_scan_conn_0), 
		.clb_scan_out(clb_scan_conn_1), 
		.clb_scan_en(clb_scan_en), 
		.conn_scan_in(conn_scan_conn_9), 
		.conn_scan_out(conn_scan_conn_10), 
		.conn_scan_en(conn_scan_en),
		.test_out_x4()
	);

	tile #(CHANNEL_ONEWAY_WIDTH, CLB_BLE_NUM, CONN_SEL_WIDTH) inst_tile_2(
		.clk(clk),
		.left_in(),
		.right_in(),
		.top_in(),
		.bottom_in(),
		.left_out(),
		.right_out(),
		.top_out(),
		.bottom_out(),
		.left_clb_out(),
		.left_clb_in(),
		.right_sb_in(),
		.right_cb_out(),
		.tio_cb_out(),
		.bottom_clb_in(),
		.clb_scan_in(clb_scan_conn_1), 
		.clb_scan_out(clb_scan_conn_2), 
		.clb_scan_en(clb_scan_en), 
		.conn_scan_in(conn_scan_conn_10), 
		.conn_scan_out(conn_scan_conn_11), 
		.conn_scan_en(conn_scan_en),
		.test_out_x4()
	);

	tile #(CHANNEL_ONEWAY_WIDTH, CLB_BLE_NUM, CONN_SEL_WIDTH) inst_tile_3(
		.clk(clk),
		.left_in(),
		.right_in(),
		.top_in(),
		.bottom_in(),
		.left_out(),
		.right_out(),
		.top_out(),
		.bottom_out(),
		.left_clb_out(),
		.left_clb_in(),
		.right_sb_in(),
		.right_cb_out(),
		.tio_cb_out(),
		.bottom_clb_in(),
		.clb_scan_in(clb_scan_conn_2), 
		.clb_scan_out(clb_scan_out), 
		.clb_scan_en(clb_scan_en), 
		.conn_scan_in(conn_scan_conn_11), 
		.conn_scan_out(conn_scan_out), 
		.conn_scan_en(conn_scan_en),
		.test_out_x4()
	);

endmodule