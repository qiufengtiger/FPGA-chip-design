`timescale 1ns / 1ps

module and2(a, b, y);
	input a, b;
	output y;
	assign y = a & b;
endmodule

module nand2(a, b, y);
	input a, b;
	output y;
	assign y = ~(a & b);
endmodule

module or2(a, b, y);
	input a, b;
	output y;
	assign y = a | b;
endmodule

module nor2(a, b, y);
	input a, b;
	output y;
	assign y = ~(a | b);
endmodule

module xor2(a, b, y);
	input a, b;
	output y;
	assign y = a ^ b;
endmodule

module mux2 (in1, in0, select, out);
	parameter WIDTH = 1;
	input [WIDTH-1:0] in0, in1;
	input select;
	output [WIDTH-1:0] out;
	assign out = (select) ? in1 : in0;
endmodule

module mux10_1bit (in, select, out);
	input [9:0] in;
	input [3:0] select;
	output out;

	// TODO

endmodule

module register (clk, rst, D, Q, wen);
	parameter WIDTH = 1;
	input clk, rst, wen;
	input [WIDTH-1:0] D;
	output reg [WIDTH-1:0] Q;

	always @(posedge clk or posedge rst) begin
		if(rst) begin
			Q <= {(WIDTH){1'b0}};
		end
		else if (wen) begin
			Q <= D;
		end
	end
endmodule

module register_scannable_1bit (clk, rst, D, Q, wen, scan_in, scan_out, scan_en);
	input clk, rst, D, wen, scan_in, scan_en;
	output reg Q;
	output scan_out;

	always @(posedge clk or posedge rst) begin
		if (rst) begin
			Q <= 1'b0;
		end
		else if (wen) begin
			if (scan_en) Q <= scan_in;
			else Q <= D;
		end
	end

	assign scan_out = Q;
endmodule



