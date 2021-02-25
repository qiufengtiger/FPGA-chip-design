`timescale 1ns/1ps
module sram(clk, raddr, rdata, waddr, wdata, we);
	parameter ADDR_WIDTH = 4;
	parameter DATA_WIDTH = 1;
	
	input clk, we;
	input [ADDR_WIDTH-1:0] raddr, waddr;
	input [DATA_WIDTH-1:0] wdata;
	output [DATA_WIDTH-1:0] rdata;

	reg [DATA_WIDTH-1:0] rdata_reg;
	reg [DATA_WIDTH-1:0] sram_data [0:2**ADDR_WIDTH-1];

	always @ (posedge clk) begin
		if(we) begin
			sram_data[waddr] <= wdata;
		end
	end

	// always @ (raddr) begin
	// 	rdata_reg <= sram_data[raddr];
	// end

	// assign rdata = rdata_reg;
	assign rdata = sram_data[rdata];
endmodule 