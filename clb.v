// https://ieeexplore.ieee.org/document/500200

`include "./sram.v"

module lut(clk, set, set_in, in, out);
	parameter WIDTH = 2;

	input clk, set;
	input [WIDTH-1:0] set_in;
	input [WIDTH-1:0] in;
	output [WIDTH-1:0] out;

	sram #(ADDR_WIDTH = WIDTH, DATA_WIDTH = 1) lut_data(.clk(clk), .raddr(in), .rdata(out), .waddr(in), .wdata(set_in), .we(set)); 
	
endmodule


// module lut2 (clk, set, set_in, in, out);
// 	input [3:0] set_in;
// 	input [1:0] in;
// 	input set;
// 	output out;

// 	reg [3:0] lut_data;

// 	always @ (posedge clk) begin
// 		out <= out;
// 		if(set) begin
// 			lut_data <= set_in;
// 		end
// 	end

// 	always @ (in) begin
// 		case(in)
// 			2'b00: out = lut_data[0];
// 			2'b01: out = lut_data[1];
// 			2'b10: out = lut_data[2];
// 			2'b11: out = lut_data[3];
// 		endcase
// 	end
// endmodule

// module lut4 (clk, set, set_in, in2, in, out);
// 	input [15:0] set_in;
// 	input [3:0] in;
// 	input set;
// 	output out;

// 	reg [15:0] lut_data;

// 	always @ (posedge clk) begin
// 		out <= out;
// 		if(set) begin
// 			lut_data <= set_in;
// 		end
// 	end

// 	always @ (in) begin
// 		case(in)
// 			4'b0000: out = lut_data[0];
// 			4'b0001: out = lut_data[1];
// 			4'b0010: out = lut_data[2];
// 			4'b0011: out = lut_data[3];
// 			4'b0100: out = lut_data[4];
// 			4'b0101: out = lut_data[5];
// 			4'b0110: out = lut_data[6];
// 			4'b0111: out = lut_data[7];
// 			4'b1000: out = lut_data[8];
// 			4'b1001: out = lut_data[9];
// 			4'b1010: out = lut_data[10];
// 			4'b1011: out = lut_data[11];
// 			4'b1100: out = lut_data[12];
// 			4'b1101: out = lut_data[13];
// 			4'b1110: out = lut_data[14];
// 			4'b1111: out = lut_data[15];
// 		endcase
// 	end
// endmodule