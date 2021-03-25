
`include "basic-gates.v"
`include "shift_reg.v"

module switch_block_edge(clk, left_in, right_in, top_in, left_out, right_out, top_out, scan_in, scan_out, scan_en);
	parameter CHANNEL_ONEWAY_WIDTH = 4;

	// channel bit numbering:
	// 0
	// |
	// 3
	//  0 - 3
	// refer to this slide for SB block diagram
	// https://docs.google.com/presentation/d/1zSjzy-MxLvTViwhgN_G6zG-wbjkTXp0XCrzEKIEBBog/edit#slide=id.gc5f0a1aeb8_1_27
	input [CHANNEL_ONEWAY_WIDTH-1:0] left_in, right_in, top_in;
	output [CHANNEL_ONEWAY_WIDTH-1:0] left_out, right_out, top_out;
	input clk, scan_in, scan_en;
	output scan_out;

	wire [CHANNEL_ONEWAY_WIDTH*2-1:0] mux_ctrl_left, mux_ctrl_right, mux_ctrl_top; 
	wire scan_conn_0, scan_conn_1;

	// each channel has 4 * 2:1 mux, which needs 4 * 1 control bits (Edited for edge case)
	shift_reg #(CHANNEL_ONEWAY_WIDTH * 1) inst_mux_config_left(.clk(clk), .out(mux_ctrl_left), .scan_in(scan_in), .scan_out(scan_conn_0), .scan_en(scan_en));
	shift_reg #(CHANNEL_ONEWAY_WIDTH * 1) inst_mux_config_right(.clk(clk), .out(mux_ctrl_right), .scan_in(scan_conn_0), .scan_out(scan_conn_1), .scan_en(scan_en));
	shift_reg #(CHANNEL_ONEWAY_WIDTH * 1) inst_mux_config_top(.clk(clk), .out(mux_ctrl_top), .scan_in(scan_conn_1), .scan_out(scan_out), .scan_en(scan_en));
    
    //What does this do? (by Jiayin)
	// assign test_out = left_out[1:0];

	// i/o mux inputs are arbitrary arch settings
	// note to my groupmates: input orderings to mux are changed from the original sv version
	// input ordering to mux: (clb_in), left, right, top, bottom, ignore current channel
	//
	// left
	mux_1bit #(2, 1) inst_mux_0_left(.in({right_in[0], top_in[1]}), .select(mux_ctrl_left[0]), .out(left_out[0]));
	mux_1bit #(2, 1) inst_mux_1_left(.in({right_in[1], top_in[2]}), .select(mux_ctrl_left[1]), .out(left_out[1]));
	mux_1bit #(2, 1) inst_mux_2_left(.in({right_in[2], top_in[3]}), .select(mux_ctrl_left[2]), .out(left_out[2]));
	mux_1bit #(2, 1) inst_mux_3_left(.in({right_in[3], top_in[0]}), .select(mux_ctrl_left[3]), .out(left_out[3]));

	// right
	mux_1bit #(2, 1) inst_mux_0_right(.in({left_in[0], top_in[2]}), .select(mux_ctrl_right[0]), .out(right_out[0]));
	mux_1bit #(2, 1) inst_mux_1_right(.in({left_in[1], top_in[1]}), .select(mux_ctrl_right[1]), .out(right_out[1]));
	mux_1bit #(2, 1) inst_mux_2_right(.in({left_in[2], top_in[0]}), .select(mux_ctrl_right[2]), .out(right_out[2]));
	mux_1bit #(2, 1) inst_mux_3_right(.in({left_in[3], top_in[3]}), .select(mux_ctrl_right[3]), .out(right_out[3]));

	// top
	mux_1bit #(2, 1) inst_mux_0_top(.in({left_in[3], right_in[2]}), .select(mux_ctrl_top[0]), .out(top_out[0]));
	mux_1bit #(2, 1) inst_mux_1_top(.in({left_in[0], right_in[1]}), .select(mux_ctrl_top[1]), .out(top_out[1]));
	mux_1bit #(2, 1) inst_mux_2_top(.in({left_in[1], right_in[0]}), .select(mux_ctrl_top[2]), .out(top_out[2]));
	mux_1bit #(2, 1) inst_mux_3_top(.in({left_in[2], right_in[3]}), .select(mux_ctrl_top[3]), .out(top_out[3]));

	// bottom 
    /*
	mux_1bit #(3, 2) inst_mux_0_bottom(.in({left_in[2], right_in[1], top_in[0]}), .select(mux_ctrl_bottom[1:0]), .out(bottom_out[0]));
	mux_1bit #(3, 2) inst_mux_1_bottom(.in({left_in[1], right_in[2], top_in[1]}), .select(mux_ctrl_bottom[3:2]), .out(bottom_out[1]));
	mux_1bit #(3, 2) inst_mux_2_bottom(.in({left_in[0], right_in[3], top_in[2]}), .select(mux_ctrl_bottom[5:4]), .out(bottom_out[2]));
	mux_1bit #(3, 2) inst_mux_3_bottom(.in({left_in[3], right_in[0], top_in[3]}), .select(mux_ctrl_bottom[7:6]), .out(bottom_out[3]));*/

endmodule