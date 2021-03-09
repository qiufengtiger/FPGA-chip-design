`include "./clb.v"

module clb_top(clk, clb_in, out, scan_in, scan_out, scan_en);
	input clk, scan_in, scan_en;
	input [3:0] clb_in;
	output out, scan_out;

	clb #(4, 1, 3) inst_clb_test_module (.clk(clk), .clb_in(clb_in), .out(out), .scan_in(scan_in), .scan_out(scan_out), .scan_en(scan_en));
endmodule