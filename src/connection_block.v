`include "basic-gates.v"
`include "shift_reg.v"

module connection_block(clk, tracks_0, tracks_1, out_0, out_1, scan_in, scan_out, scan_en);
	parameter CHANNEL_ONEWAY_WIDTH = 4;

	// here tracks 0 and 1 are in fact half of channel, with width of CHANNEL_WIDTH/2
	// using 0 and 1 to distinguish between tracks travelling in opposite directions
	//
	// The standard used in this verilog implementation:
	// <- tracks_0 ^ out_0
	// -> tracks_1 v out_1
	// within tracks:
	// <- 0_0
	// -> 1_0
	// <- 0_1
	// -> 1_1 etc
	// refer to this slide for CB block diagram
	// https://docs.google.com/presentation/d/1zSjzy-MxLvTViwhgN_G6zG-wbjkTXp0XCrzEKIEBBog/edit#slide=id.gc5f0a1aeb8_1_27
	input [CHANNEL_ONEWAY_WIDTH-1:0] tracks_0, tracks_1;
	input clk, scan_in, scan_en;
	output out_0, out_1, scan_out;

	wire [3:0] out_config;

	// each out is controlled by 1 4:1 mux, so in total 2*2 contorl bits
	shift_reg #(4) inst_cb_out_config(.clk(clk), .out(out_config), .scan_in(scan_in), .scan_out(scan_out), .scan_en(scan_en));

	mux_1bit #(4, 2) inst_cb_out_mux_0(.in({tracks_0[0], tracks_1[0], tracks_0[2], tracks_1[2]}), .select(out_config[1:0]), .out(out_0));
	mux_1bit #(4, 2) inst_cb_out_mux_1(.in({tracks_0[1], tracks_1[1], tracks_0[3], tracks_1[3]}), .select(out_config[3:2]), .out(out_1));
	
endmodule