// https://ieeexplore.ieee.org/document/500200

`include "./sram.v"
`include "./basic-gates.v"
`include "./shift_reg.v"

module clb(clk, clb_in, out, scan_in, scan_out, scan_en);
	parameter CLB_WIDTH = 4;
	parameter CONN_WIDTH = 4;
	parameter CLB_NUM = 1;
	input clk, scan_in;
	input [CLB_WIDTH-1:0] in;
	// 1 output per ble
	output [CLB_NUM-1:0] out;


	// ble #(CLB_WIDTH) inst_ble_0();
	// ble #(CLB_WIDTH) inst_ble_0();


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

module clb_complete_conn(clk, complete_in, out, scan_in, scan_out, scan_en);
	parameter IN_WIDTH = 5;
	parameter OUT_WIDTH = 4;
	parameter MUX_SEL_WIDTH = 3;

	input [IN_WIDTH-1:0] complete_in;
	input clk, scan_in, scan_en;
	output [OUT_WIDTH-1:0] out;
	output scan_out;

	wire [(MUX_SEL_WIDTH * OUT_WIDTH)-1:0] mux_config;

	// store complete conn config
	shift_reg #(MUX_SEL_WIDTH * OUT_WIDTH) inst_config_sftreg(.clk(clk), .out(mux_config), .scan_in(scan_in), .scan_out(scan_out), .scan_en(scan_en));

	genvar i;
	generate
		for(i = 0; i < OUT_WIDTH; i++) begin
			// wire [] mux_in = {{(2**MUX_SEL_WIDTH - IN_WIDTH){1'b0}}, complete_in};
			mux_1bit #(IN_WIDTH, MUX_SEL_WIDTH) inst_complete_mux(.in(complete_in), .out(out[i]), .select(mux_config[(i * 3 + 2):i * 3]));
		end
	endgenerate


endmodule






