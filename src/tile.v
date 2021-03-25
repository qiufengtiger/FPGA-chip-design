`include "clb.v"
`include "switch_block.v"
`include "connection_block.v"
`include "basic-gates.v"
`include "shift_reg.v"

// refer to this slide for block diagram
// https://docs.google.com/presentation/d/1zSjzy-MxLvTViwhgN_G6zG-wbjkTXp0XCrzEKIEBBog/edit#slide=id.gc5f0a1aeb8_1_27
// tile structure:
//   |     |
// - CB  - SB -
//   |     |
// - CLB - CB -
//   |     |
module tile(clk, left_in, right_in, top_in, bottom_in, left_out, right_out, top_out, bottom_out, 
	left_clb_out, left_clb_in, bottom_clb_in, right_sb_in, test_out_x4,
	top_cb_out, right_cb_out, 
	clb_scan_in, clb_scan_out, clb_scan_en, conn_scan_in, conn_scan_out, conn_scan_en);
	parameter CHANNEL_ONEWAY_WIDTH = 4;
	parameter CLB_BLE_NUM = 1;
	parameter CONN_SEL_WIDTH = 3;

	input [CHANNEL_ONEWAY_WIDTH-1:0] left_in, right_in, top_in, bottom_in;
	output [CHANNEL_ONEWAY_WIDTH-1:0] left_out, right_out, top_out, bottom_out;
	input clk, clb_scan_in, clb_scan_en, conn_scan_in, conn_scan_en;
	input left_clb_in, bottom_clb_in, right_sb_in;
	output left_clb_out;
	output clb_scan_out, conn_scan_out, top_cb_out, right_cb_out;

	// a test pin, used in HDL verification
	output [CHANNEL_ONEWAY_WIDTH-1:0] test_out_x4;

	wire conn_scan_conn_0, conn_scan_conn_1;
	// top: 0, right: 1, bottom: 2, left: 3
	wire clb_in_0, clb_in_1, clb_in_2, clb_in_3;
	wire clb_out;

	assign left_clb_out = clb_out;

	assign clb_in_2 = bottom_clb_in;
	assign clb_in_3 = left_clb_in;
 
	assign test_out_x4 = {clb_in_3, clb_in_2, clb_in_1, clb_in_0};

	// clb_scanchain: scan_in -> clb -> scan_out
	// conn_scanchain: scan_in -> sb -> cb_top -> cb_right -> scan_out
	switch_block #(CHANNEL_ONEWAY_WIDTH) inst_sb(
		.clk(clk), 
		.left_in(left_in), 
		.right_in(right_in), 
		.top_in(top_in), 
		.bottom_in(bottom_in), 
		.left_out(left_out), 
		.right_out(right_out), 
		.top_out(top_out), 
		.bottom_out(bottom_out), 
		.left_clb_in(clb_out), 
		.right_clb_in(right_sb_in), 
		.scan_in(conn_scan_in), 
		.scan_out(conn_scan_conn_0), 
		.scan_en(conn_scan_en)
	);

	connection_block #(CHANNEL_ONEWAY_WIDTH) inst_cb_top(
		.clk(clk), 
		.tracks_0(left_out), 
		.tracks_1(left_in), 
		.out_0(top_cb_out), 
		.out_1(clb_in_0), 
		.scan_in(conn_scan_conn_0), 
		.scan_out(conn_scan_conn_1), 
		.scan_en(conn_scan_en)
	);

	connection_block #(CHANNEL_ONEWAY_WIDTH) inst_cb_right(
		.clk(clk), 
		.tracks_0(bottom_in), 
		.tracks_1(bottom_out), 
		.out_0(clb_in_1), 
		.out_1(right_cb_out), 
		.scan_in(conn_scan_conn_1), 
		.scan_out(conn_scan_out), 
		.scan_en(conn_scan_en)
	);

	clb #(CHANNEL_ONEWAY_WIDTH, CLB_BLE_NUM, CONN_SEL_WIDTH) inst_clb(
		.clk(clk), 
		.clb_in({clb_in_3, clb_in_2, clb_in_1, clb_in_0}), 
		.out(clb_out), 
		.scan_in(clb_scan_in), 
		.scan_out(clb_scan_out), 
		.scan_en(clb_scan_en)
	);

endmodule