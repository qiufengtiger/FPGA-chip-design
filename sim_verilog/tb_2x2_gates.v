module tb_2x2_gates();

	reg clk = 0;
	reg scan_clk = 0;
	reg reset = 0;
	reg clb_scan_in, clb_scan_en, conn_scan_in, conn_scan_en;

	reg start_fpga_clk = 0;	wire clb_scan_out, conn_scan_out;
    reg [3:0] fpga_in;
    wire [3:0] fpga_out;
    
    // reg [19:0] fpga_input=20'h0;
    
    // genvar i;
	// generate
	// 	for(i = 0; i < 20; i = i + 1) begin
	// 		assign fpga_io[i] = is_fpga_input[i] ? fpga_input[i] : 1'bz;
	// 	end
    // endgenerate
    
    //assign fpga_io[14] = tristate ? fpga_reset_in : 1'bz;
    
    fpga_core_2x2 inst_chip(
		.clk(clk),
		.scan_clk(scan_clk),
		.fpga_in(fpga_in),
        .fpga_out(fpga_out),
		.clb_scan_in(clb_scan_in),
		.clb_scan_out(clb_scan_out),
		.clb_scan_en(clb_scan_en),
		.conn_scan_in(conn_scan_in),
		.conn_scan_out(conn_scan_out),
		.conn_scan_en(conn_scan_en),
		.reset(reset)
	);

	initial begin
		clk = 0; scan_clk = 0; reset = 0; clb_scan_in = 0; clb_scan_en = 0; conn_scan_in = 0; conn_scan_en = 0;
	end

	always begin
		#5 scan_clk = ~scan_clk;
	end
    always @(*) begin
		if (start_fpga_clk)
			clk = scan_clk;
		else
			clk = 0;
	end	
    initial begin
		$dumpfile("tb_2x2_gates.vcd");
		$dumpvars(0, tb_2x2_gates);
    		#10 clb_scan_en <= 1; clb_scan_in <= 1'b1;
		#10 clb_scan_in <= 1'b1;
		#10 clb_scan_in <= 1'b0;
		#10 clb_scan_in <= 1'b0;
		#10 clb_scan_in <= 1'b1;
		#10 clb_scan_in <= 1'b1;
		#10 clb_scan_in <= 1'b0;
		#10 clb_scan_in <= 1'b0;
		#10 clb_scan_in <= 1'b0;
		#10 clb_scan_in <= 1'b0;
		#10 clb_scan_in <= 1'b0;
		#10 clb_scan_in <= 1'b0;
		#10 clb_scan_in <= 1'b0;
		#10 clb_scan_in <= 1'b0;
		#10 clb_scan_in <= 1'b0;
		#10 clb_scan_in <= 1'b0;
		#10 clb_scan_in <= 1'b0;
		#10 clb_scan_in <= 1'b0;
		#10 clb_scan_in <= 1'b0;
		#10 clb_scan_in <= 1'b1;
		#10 clb_scan_in <= 1'b0;
		#10 clb_scan_in <= 1'b1;
		#10 clb_scan_in <= 1'b0;
		#10 clb_scan_in <= 1'b1;
		#10 clb_scan_in <= 1'b0;
		#10 clb_scan_in <= 1'b1;
		#10 clb_scan_in <= 1'b0;
		#10 clb_scan_in <= 1'b1;
		#10 clb_scan_in <= 1'b1;
		#10 clb_scan_in <= 1'b1;
		#10 clb_scan_in <= 1'b1;
		#10 clb_scan_in <= 1'b1;
		#10 clb_scan_in <= 1'b1;
		#10 clb_scan_in <= 1'b1;
		#10 clb_scan_in <= 1'b1;
		#10 clb_scan_in <= 1'b1;
		#10 clb_scan_in <= 1'b1;
		#10 clb_scan_in <= 1'b1;
		#10 clb_scan_in <= 1'b1;
		#10 clb_scan_in <= 1'b0;
		#10 clb_scan_in <= 1'b0;
		#10 clb_scan_in <= 1'b1;
		#10 clb_scan_in <= 1'b1;
		#10 clb_scan_in <= 1'b0;
		#10 clb_scan_in <= 1'b0;
		#10 clb_scan_in <= 1'b0;
		#10 clb_scan_in <= 1'b0;
		#10 clb_scan_in <= 1'b0;
		#10 clb_scan_in <= 1'b1;
		#10 clb_scan_in <= 1'b0;
		#10 clb_scan_in <= 1'b1;
		#10 clb_scan_in <= 1'b0;
		#10 clb_scan_in <= 1'b1;
		#10 clb_scan_in <= 1'b0;
		#10 clb_scan_in <= 1'b1;
		#10 clb_scan_in <= 1'b0;
		#10 clb_scan_in <= 1'b1;
		#10 clb_scan_in <= 1'b1;
		#10 clb_scan_in <= 1'b0;
		#10 clb_scan_in <= 1'b0;
		#10 clb_scan_in <= 1'b0;
		#10 clb_scan_in <= 1'b0;
		#10 clb_scan_in <= 1'b0;
		#10 clb_scan_in <= 1'b0;
		#10 clb_scan_in <= 1'b0;
		#10 clb_scan_in <= 1'b0;
		#10 clb_scan_in <= 1'b0;
		#10 clb_scan_in <= 1'b0;
		#10 clb_scan_in <= 1'b0;
		#10 clb_scan_in <= 1'b0;
		#10 clb_scan_in <= 1'b0;
		#10 clb_scan_in <= 1'b0;
		#10 clb_scan_in <= 1'b0;
		#10 clb_scan_in <= 1'b0;
		#10 clb_scan_in <= 1'b0;
		#10 clb_scan_in <= 1'b0;
		#10 clb_scan_in <= 1'b0;
		#10 clb_scan_in <= 1'b0;
		#10 clb_scan_in <= 1'b0;
		#10 clb_scan_in <= 1'b0;
		#10 clb_scan_in <= 1'b0;
		#10 clb_scan_in <= 1'b0;
		#10 clb_scan_in <= 1'b0;
		#10 clb_scan_in <= 1'b0;
		#10 clb_scan_in <= 1'b0;
		#10 clb_scan_in <= 1'b0;
		#10 clb_scan_in <= 1'b1;
		#10 clb_scan_in <= 1'b0;
		#10 clb_scan_in <= 1'b0;
		#10 clb_scan_in <= 1'b0;
		#10 clb_scan_in <= 1'b0;
		#10 clb_scan_in <= 1'b0;
		#10 clb_scan_in <= 1'b0;
		#10 clb_scan_in <= 1'b0;
		#10 clb_scan_in <= 1'b0;
		#10 clb_scan_in <= 1'b0;
		#10 clb_scan_in <= 1'b0;
		#10 clb_scan_in <= 1'b0;
		#10 clb_scan_in <= 1'b0;
		#10 clb_scan_in <= 1'b0;
		#10 clb_scan_in <= 1'b0;
		#10 clb_scan_in <= 1'b0;
		#10 clb_scan_in <= 1'b0;
		#10 clb_scan_in <= 1'b1;
		#10 clb_scan_in <= 1'b0;
		#10 clb_scan_in <= 1'b1;
		#10 clb_scan_in <= 1'b1;
		#10 clb_scan_in <= 1'b0;
		#10 clb_scan_in <= 1'b1;
		#10 clb_scan_in <= 1'b1;
		#10 clb_scan_in <= 1'b0;
		#10 clb_scan_in <= 1'b1;
		#10 clb_scan_in <= 1'b1;
		#10 clb_scan_in <= 1'b0;
		#10 clb_scan_in <= 1'b1;
		#10 clb_scan_in <= 1'b1;
		#10 clb_scan_en <= 0;
		#10 conn_scan_en <= 1; conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b1;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b1;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b1;
		#10 conn_scan_in <= 1'b1;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b1;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b1;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b1;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b1;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b1;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b1;
		#10 conn_scan_in <= 1'b1;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b1;
		#10 conn_scan_in <= 1'b1;
		#10 conn_scan_in <= 1'b1;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b1;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b1;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b1;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b1;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b1;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b1;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b1;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b1;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b1;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b0;
		#10 conn_scan_in <= 1'b1;
		#10 conn_scan_en <= 0; start_fpga_clk <= 1;
		#10 reset <= 1;
		#10 reset <= 0;
		#10 fpga_in[1] <= 0;
 		#10 fpga_in[2] <= 1; 
		#4720 $finish;
	 end
endmodule