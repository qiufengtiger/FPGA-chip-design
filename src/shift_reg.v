`timescale 1ns/1ps
module shift_reg(clk, out, scan_in, scan_out, scan_en);
	parameter SIZE = 4;
	input clk, scan_in, scan_en;
	output [SIZE-1:0] out;
	output scan_out;

	reg [SIZE-1:0] reg_data;
	reg scan_out_value;

	always @(posedge clk) begin
		if(scan_en) begin
			scan_out_value <= reg_data[SIZE-1];
			reg_data <= {reg_data[SIZE-2:0], scan_in};
		end
	end
	// assign scan_out = scan_out_value;
	assign scan_out = reg_data[SIZE-1];
	assign out = reg_data;
endmodule

module shift_reg_1bit(clk, out, scan_in, scan_out, scan_en);
	input clk, scan_in, scan_en;
	output out, scan_out;

	reg reg_data;
	reg scan_out_value;

	always @(posedge clk) begin
		if (scan_en) begin
			scan_out_value <= reg_data;
			reg_data <= scan_in;
		end
	end
	// assign scan_out = scan_out_value;
	assign scan_out = reg_data;
	assign out = reg_data;
endmodule