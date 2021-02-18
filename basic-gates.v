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

module mux (in1, in0, select, out);
	parameter WIDTH = 1;
	input [WIDTH-1:0] in0, in1;
	input select;
	output [WIDTH-1:0] out;
	assign out = (select) ? in1 : in0;
endmodule