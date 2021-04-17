`timescale 1ns/1ps
module sram(scan_clk, sram_data, scan_in, scan_out, scan_en);
	parameter SIZE = 16;
	
	input scan_clk, scan_en, scan_in;
	//input [(2**ADDR_WIDTH)-1:0] rdata;
	output scan_out;
	
	output reg [SIZE-1 : 0] sram_data;

	always @ (posedge scan_clk) begin
		if(scan_en) begin
			sram_data <= {sram_data[SIZE-2:0], scan_in};
		end
		else begin
		    sram_data <= sram_data;
		end
	end
	assign scan_out = sram_data[SIZE-1];
	// assign rdata = sram_data[raddr];
endmodule 
