`timescale 1ns/1ps
module shift_reg(scan_clk, out, scan_in, scan_out, scan_en);
	parameter SIZE = 4;
	input scan_clk, scan_in, scan_en;
	output [SIZE-1:0] out;
	output scan_out;

	reg [SIZE-1:0] reg_data;

	always @(posedge scan_clk) begin
		if(scan_en) begin
			reg_data <= {reg_data[SIZE-2:0], scan_in};
		end
	end
	assign scan_out = reg_data[SIZE-1];
	assign out = reg_data;
endmodule

module shift_reg_1bit(scan_clk, out, scan_in, scan_out, scan_en);
	input scan_clk, scan_in, scan_en;
	output scan_out;

	output reg out;

	always @(posedge scan_clk) begin
		if (scan_en) begin
			out <= scan_in;
		end
	end
	assign scan_out = out;
endmodule
