// `include "basic-gates.v"
// `include "shift_reg.v"

module switch_block(clk, left_in, right_in, top_in, bottom_in, left_out, right_out, top_out, bottom_out, left_clb_in, right_clb_in, scan_in, scan_out, scan_en);
	parameter CHANNEL_ONEWAY_WIDTH = 4;

	
	// refer to this slide for SB block diagram
	// https://docs.google.com/presentation/d/1zSjzy-MxLvTViwhgN_G6zG-wbjkTXp0XCrzEKIEBBog/edit#slide=id.gc5f0a1aeb8_1_27
	input [CHANNEL_ONEWAY_WIDTH-1:0] left_in, right_in, top_in, bottom_in;
	output [CHANNEL_ONEWAY_WIDTH-1:0] left_out, right_out, top_out, bottom_out;
	input clk, scan_in, scan_en, left_clb_in, right_clb_in;
	output scan_out;

	wire [CHANNEL_ONEWAY_WIDTH*2-1:0] mux_ctrl_left, mux_ctrl_right, mux_ctrl_top, mux_ctrl_bottom; 
	wire scan_conn_0, scan_conn_1, scan_conn_2;

	// each channel has 4 * 3:1 or 4:1 mux, which needs 4 * 2 control bits
	shift_reg #(CHANNEL_ONEWAY_WIDTH * 2) inst_mux_config_left(.clk(clk), .out(mux_ctrl_left), .scan_in(scan_in), .scan_out(scan_conn_0), .scan_en(scan_en));
	shift_reg #(CHANNEL_ONEWAY_WIDTH * 2) inst_mux_config_right(.clk(clk), .out(mux_ctrl_right), .scan_in(scan_conn_0), .scan_out(scan_conn_1), .scan_en(scan_en));
	shift_reg #(CHANNEL_ONEWAY_WIDTH * 2) inst_mux_config_top(.clk(clk), .out(mux_ctrl_top), .scan_in(scan_conn_1), .scan_out(scan_conn_2), .scan_en(scan_en));
	shift_reg #(CHANNEL_ONEWAY_WIDTH * 2) inst_mux_config_bottom(.clk(clk), .out(mux_ctrl_bottom), .scan_in(scan_conn_2), .scan_out(scan_out), .scan_en(scan_en));

	// i/o mux inputs are arbitrary arch settings
	// note to my groupmates: input orderings to mux are changed from the original sv version
	// input ordering to mux: (clb_in), left, right, top, bottom, ignore current channel
	//
	// left
	mux_1bit #(3, 2) inst_mux_0_left(.in({right_in[0], top_in[1], bottom_in[2]}), .select(mux_ctrl_left[1:0]), .out(left_out[0]));
	mux_1bit #(3, 2) inst_mux_1_left(.in({right_in[1], top_in[2], bottom_in[1]}), .select(mux_ctrl_left[3:2]), .out(left_out[1]));
	mux_1bit #(3, 2) inst_mux_2_left(.in({right_in[2], top_in[3], bottom_in[0]}), .select(mux_ctrl_left[5:4]), .out(left_out[2]));
	mux_1bit #(4, 2) inst_mux_3_left(.in({left_clb_in, right_in[3], top_in[0], bottom_in[3]}), .select(mux_ctrl_left[7:6]), .out(left_out[3]));

	// right
	mux_1bit #(3, 2) inst_mux_0_right(.in({left_in[0], top_in[2], bottom_in[3]}), .select(mux_ctrl_right[1:0]), .out(right_out[0]));
	mux_1bit #(3, 2) inst_mux_1_right(.in({left_in[1], top_in[1], bottom_in[0]}), .select(mux_ctrl_right[3:2]), .out(right_out[1]));
	mux_1bit #(3, 2) inst_mux_2_right(.in({left_in[2], top_in[0], bottom_in[1]}), .select(mux_ctrl_right[5:4]), .out(right_out[2]));
	mux_1bit #(4, 2) inst_mux_3_right(.in({right_clb_in, left_in[3], top_in[3], bottom_in[2]}), .select(mux_ctrl_right[7:6]), .out(right_out[3]));

	// top
	mux_1bit #(3, 2) inst_mux_0_top(.in({left_in[3], right_in[2], bottom_in[0]}), .select(mux_ctrl_top[1:0]), .out(top_out[0]));
	mux_1bit #(3, 2) inst_mux_1_top(.in({left_in[0], right_in[1], bottom_in[1]}), .select(mux_ctrl_top[3:2]), .out(top_out[1]));
	mux_1bit #(3, 2) inst_mux_2_top(.in({left_in[1], right_in[0], bottom_in[2]}), .select(mux_ctrl_top[5:4]), .out(top_out[2]));
	mux_1bit #(3, 2) inst_mux_3_top(.in({left_in[2], right_in[3], bottom_in[3]}), .select(mux_ctrl_top[7:6]), .out(top_out[3]));

	// bottom
	mux_1bit #(3, 2) inst_mux_0_bottom(.in({left_in[2], right_in[1], top_in[0]}), .select(mux_ctrl_bottom[1:0]), .out(bottom_out[0]));
	mux_1bit #(3, 2) inst_mux_1_bottom(.in({left_in[1], right_in[2], top_in[1]}), .select(mux_ctrl_bottom[3:2]), .out(bottom_out[1]));
	mux_1bit #(3, 2) inst_mux_2_bottom(.in({left_in[0], right_in[3], top_in[2]}), .select(mux_ctrl_bottom[5:4]), .out(bottom_out[2]));
	mux_1bit #(3, 2) inst_mux_3_bottom(.in({left_in[3], right_in[0], top_in[3]}), .select(mux_ctrl_bottom[7:6]), .out(bottom_out[3]));

endmodule