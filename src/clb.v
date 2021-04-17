// https://ieeexplore.ieee.org/document/500200

//`include "sram.v"
// `include "basic-gates.v"
// `include "shift_reg.v"

module clb(clk, scan_clk, clb_in, out, scan_in, scan_out, scan_en, reset);
	parameter CLB_IN_WIDTH = 4;
	parameter CLB_BLE_NUM = 1;
	// sqrt(CLB_IN_WIDTH + CLB_BLE_NUM)
	parameter CONN_SEL_WIDTH = 3;

	input clk, scan_clk, scan_in, scan_en, reset;
	input [CLB_IN_WIDTH-1:0] clb_in;
	// 1 output per ble
	output [CLB_BLE_NUM-1:0] out;
	output scan_out;

	// scan chain route: 
	// scan_in -> is_comb_reg -> scan_conn_0 -> complete -> scan_conn_1 -> ble -> scan_out
	wire scan_conn_0;
	wire scan_conn_1;
	wire [CLB_IN_WIDTH-1:0] ble_in_conn;
	wire is_comb;
    wire [11:0] mux_config;
    wire [5:0] complete_in = {1'b0, out, clb_in};

	//shift_reg_1bit inst_is_comb_sftreg(.scan_clk(scan_clk), .out(is_comb), .scan_in(scan_in), .scan_out(scan_conn_0), .scan_en(scan_en));
	
	
	
	sram #(13) inst_lut_data(.scan_clk(scan_clk), .sram_data({mux_config, is_comb}), .scan_in(scan_in), 
	                            .scan_out(scan_conn_1), .scan_en(scan_en)); 
    assign ble_in_conn[0] = complete_in[mux_config[2:0]];
    assign ble_in_conn[1] = complete_in[mux_config[5:3]];
    assign ble_in_conn[2] = complete_in[mux_config[8:6]];
    assign ble_in_conn[3] = complete_in[mux_config[11:9]];
	
	
	//clb_complete_conn #((CLB_IN_WIDTH + CLB_BLE_NUM + 1), CLB_IN_WIDTH, CONN_SEL_WIDTH) inst_clb_ble_conn(.scan_clk(scan_clk), 
	  //  .complete_in({1'b0, out, clb_in}), .out(ble_in_conn), 
		//.scan_in(scan_conn_0), .scan_out(scan_conn_1), .scan_en(scan_en));
	
	ble #(CLB_IN_WIDTH) inst_ble(.clk(clk), .scan_clk(scan_clk), .is_comb(is_comb), .lut_in(ble_in_conn), .out(out), .scan_in(scan_conn_1), .scan_out(scan_out), .scan_en(scan_en), .*);
endmodule

module ble(clk, scan_clk, is_comb, lut_in, out, scan_in, scan_out, scan_en, reset);
	parameter WIDTH = 4;

	input clk, scan_clk, is_comb, scan_in, scan_en, reset;
	input [WIDTH-1:0] lut_in;
	output out, scan_out;
    
    wire [(WIDTH**2)-1:0] sram_data;
    
	wire lut_table_out = sram_data[lut_in];
	reg lut_ff;
    
	// sram serves as the lut
	sram #(16) inst_lut_data(.scan_clk(scan_clk), .sram_data(sram_data), .scan_in(scan_in), 
	                            .scan_out(scan_out), .scan_en(scan_en)); 
	
	
	mux2 #(1) inst_lut_mux(.in1(lut_table_out), .in0(lut_ff), .select(is_comb), .out(out));

	always @ (posedge clk) begin
		if(reset) 
			lut_ff <= 1'b0;
		else
			lut_ff <= lut_table_out;
	end

endmodule

module clb_complete_conn(scan_clk, complete_in, out, scan_in, scan_out, scan_en);
	parameter IN_WIDTH = 6;
	parameter OUT_WIDTH = 4;
	parameter MUX_SEL_WIDTH = 3;

	input [IN_WIDTH-1:0] complete_in;
	input scan_clk, scan_in, scan_en;
	output [OUT_WIDTH-1:0] out;
	output scan_out;

	wire [(MUX_SEL_WIDTH * OUT_WIDTH)-1:0] mux_config;

	// store complete conn config
	//shift_reg #(MUX_SEL_WIDTH * OUT_WIDTH) inst_config_sftreg(.scan_clk(scan_clk), .out(mux_config), .scan_in(scan_in), .scan_out(scan_out), .scan_en(scan_en));
    sram #(MUX_SEL_WIDTH * OUT_WIDTH) inst_lut_data(.scan_clk(scan_clk), .sram_data(mux_config), .scan_in(scan_in), 
	                            .scan_out(scan_out), .scan_en(scan_en)); 
    assign out[0] = complete_in[mux_config[2:0]];
    assign out[1] = complete_in[mux_config[5:3]];
    assign out[2] = complete_in[mux_config[8:6]];
    assign out[3] = complete_in[mux_config[11:9]];
/*
	genvar i;
	generate
		for(i = 0; i < OUT_WIDTH; i = i + 1) begin
			// wire [] mux_in = {{(2**MUX_SEL_WIDTH - IN_WIDTH){1'b0}}, complete_in};
			mux_1bit #(IN_WIDTH, MUX_SEL_WIDTH) inst_complete_mux(.in(complete_in), .out(out[i]), .select(mux_config[(i * 3 + 2):i * 3]));
		end
	endgenerate
*/
endmodule






