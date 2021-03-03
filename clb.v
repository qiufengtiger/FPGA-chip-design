// https://ieeexplore.ieee.org/document/500200

`include "./sram.v"
`include "./basic-gates.v"

module clb(clk, in, out, scan_in, scan_out);
	parameter CLB_WIDTH = 4;
	parameter CLB_NUM = 10;
	input clk, scan_in;
	input [CLB_WIDTH-1:0] in;
	// 1 output per ble
	output [CLB_NUM-1:0] out;


endmodule

module ble(clk, set, set_in, is_comb, lut_in, out);
	parameter WIDTH = 4;

	input clk, set, is_comb;
	input [WIDTH-1:0] set_in;
	input [WIDTH-1:0] lut_in;
	output out;

	wire lut_table_out;
	reg lut_ff;

	// sram serves as the lut
	sram #(WIDTH, 1) lut_data(.clk(clk), .raddr(lut_in), .rdata(lut_table_out), .waddr(lut_in), .wdata(set_in), .we(set)); 
	mux2 #(1) lut_mux(.in1(lut_table_out), .in0(lut_ff), .select(is_comb), .out(out));

	always @ (posedge clk) begin
		lut_ff <= lut_table_out;
	end

endmodule