module sram(scan_clk, raddr, rdata, scan_in, scan_out, scan_en);
	parameter ADDR_WIDTH = 4;
	// parameter DATA_WIDTH = 1;
	
	input scan_clk, scan_en;
	input [ADDR_WIDTH-1:0] raddr;
	input scan_in;
	output rdata, scan_out;
	// input [DATA_WIDTH-1:0] wdata, scan_in;
	// output [DATA_WIDTH-1:0] rdata, scan_out;

	// reg [DATA_WIDTH-1:0] sram_data [0:(2**ADDR_WIDTH)-1];
	// reg [DATA_WIDTH-1:0] scan_out_value;

	// reg scan_out_value;
	reg [(2**ADDR_WIDTH)-1 : 0] sram_data;


	always @ (posedge scan_clk) begin
		if(scan_en) begin
			sram_data <= {sram_data[(2**ADDR_WIDTH)-2:0], scan_in};
		end 
	end
	assign scan_out = sram_data[(2**ADDR_WIDTH)-1];
	// assign rdata = sram_data[raddr];

	wire is_msb = (raddr == 2**ADDR_WIDTH-1);

	mux2 inst_rdata_mux(.in1(scan_out), .in0(sram_data[raddr]), .select(is_msb), .out(rdata));

endmodule 