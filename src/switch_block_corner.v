module switch_block_corner(clk, left_in, right_in, top_in, left_out, right_out, top_out);
	parameter CHANNEL_ONEWAY_WIDTH = 4;

	// channel bit numbering:
	// 0
	// |
	// 3
	//  0 - 3
	// refer to this slide for SB block diagram
	// https://docs.google.com/presentation/d/1zSjzy-MxLvTViwhgN_G6zG-wbjkTXp0XCrzEKIEBBog/edit#slide=id.gc5f0a1aeb8_1_27
	input [CHANNEL_ONEWAY_WIDTH-1:0] right_in, top_in;
	output [CHANNEL_ONEWAY_WIDTH-1:0] right_out, top_out;

	assign right_out[0] = top_in[2];
	assign right_out[1] = top_in[1];
	assign right_out[2] = top_in[0];
	assign right_out[3] = top_in[3];

	assign top_out[0] = right_in[2];
	assign top_out[1] = right_in[1];
	assign top_out[2] = right_in[0];
	assign top_out[3] = right_in[3];

endmodule