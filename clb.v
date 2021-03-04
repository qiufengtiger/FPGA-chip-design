// https://ieeexplore.ieee.org/document/500200

`include "./sram.v"
`include "./basic-gates.v"

module clb(clk, in, out, scan_in, scan_out, scan_en);
	parameter CLB_WIDTH = 4;
	parameter CONN_WIDTH = 4;
	parameter CLB_NUM = 10;
	input clk, scan_in;
	input [CLB_WIDTH-1:0] in;
	// 1 output per ble
	output [CLB_NUM-1:0] out;

	sram #(CONN_WIDTH) inst_conn_config(); 

	ble #(CLB_WIDTH) inst_ble_0();
	ble #(CLB_WIDTH) inst_ble_0();


endmodule

module ble(clk, is_comb, lut_in, out, scan_in, scan_out, scan_en);
	parameter WIDTH = 4;

	input clk, set, is_comb, scan_in, scan_en;
	input [WIDTH-1:0] lut_in;
	output out, scan_out;

	wire lut_table_out;
	reg lut_ff;

	// sram serves as the lut
	sram #(WIDTH) inst_lut_data(.clk(clk), .raddr(lut_in), .rdata(lut_table_out), .waddr(lut_in), .wdata(set_in), .we(1'b0), .scan_in(scan_in), .scan_out(scan_out), .scan_en(scan_en)); 
	mux2 #(1) inst_lut_mux(.in1(lut_table_out), .in0(lut_ff), .select(is_comb), .out(out));

	always @ (posedge clk) begin
		lut_ff <= lut_table_out;
	end

endmodule

module clb_interconnect()
	parameter IN_WIDTH = 5;
	parameter OUT_WIDTH = 10;

endmodule