/*note: datapath signals to be connected for 8x8 to fpga_top are:
    [31:0] left_in, left_out, bottom_in, bottom_out, (to edge sb)
    [7:0] left_clb_out (to edge sb)
    [7:0] left_clb_in, bottom_clb_in (to edge cb)
    
*/
`include "tile_8x1.v"
module tile_8x8 (
    clk, scan_clk, clb_scan_in, clb_scan_out, clb_scan_en, conn_scan_in, conn_scan_out, conn_scan_en,
    left_in, right_in, top_in, bottom_in, left_out, right_out, top_out, bottom_out, 
	left_clb_out, left_clb_in, bottom_clb_in, right_sb_in, 
	top_cb_out, right_cb_out
);
    //clk + scan chain
    input clk, scan_clk, clb_scan_in,clb_scan_en, conn_scan_in, conn_scan_en;
    output clb_scan_out, conn_scan_out;
    
    //scaling singals for vertical expansion, non-scaling for horizontal 
    input [31:0] left_in, right_in;
    output [31:0] left_out, right_out;
    input [7:0] left_clb_in, right_sb_in;
    output [7:0] left_clb_out, right_cb_out; 

    //scaling signals for horizontal expansion
    input [31:0] top_in, bottom_in;
    output [31:0] top_out, bottom_out;
    input [7:0] bottom_clb_in;
    output [7:0] top_cb_out;

    //interconnect
    wire [31:0] left_right_conn, right_left_conn;
    wire [7:0] cb_conn, sb_conn;
    wire clb_scan_conn, conn_scan_conn;

    /*ALL inputs: (Classifeid for the case of horizontal expansion)
    //Inferred
    clk, scan_clk,  
	clb_scan_en, conn_scan_en
    
    //One or the other
    clb_scan_in, clb_scan_out,
    conn_scan_in, conn_scan_out,
    left_in, right_in, 
    left_out, right_out,
    left_clb_out, right_sb_in
    left_clb_in, right_cb_out,
    
    //Change index
    top_in, bottom_in, top_out, bottom_out, bottom_clb_in, top_cb_out, */

    tile_8x4 tile_8x4_left(
        .top_in(top_in[15:0]),
        .top_out(top_out[15:0]),
		.bottom_in(bottom_in[15:0]),
		.bottom_out(bottom_out[15:0]),
        .top_cb_out(top_cb_out[3:0]),
		.bottom_clb_in(bottom_clb_in[3:0]), 
        .right_out(left_right_conn),
        .right_in(right_left_conn),
		.right_sb_in(sb_conn),
		.right_cb_out(cb_conn),
		.clb_scan_out(clb_scan_conn),   
		.conn_scan_out(conn_scan_conn), 
        .*
    );

    tile_8x4 tile_8x4_right(
        .top_in(top_in[31:16]),
        .top_out(top_out[31:16]),
		.bottom_in(bottom_in[31:16]),
		.bottom_out(bottom_out[31:16]),
        .top_cb_out(top_cb_out[7:4]),
		.bottom_clb_in(bottom_clb_in[7:4]), 
        .left_in(left_right_conn),
        .left_out(right_left_conn),
		.left_clb_out(sb_conn),
		.left_clb_in(cb_conn),
		.clb_scan_in(clb_scan_conn),   
		.conn_scan_in(conn_scan_conn),
        .* 
    );

endmodule

module tile_8x4 (
    clk, scan_clk, clb_scan_in, clb_scan_out, clb_scan_en, conn_scan_in, conn_scan_out, conn_scan_en,
    left_in, right_in, top_in, bottom_in, left_out, right_out, top_out, bottom_out, 
	left_clb_out, left_clb_in, bottom_clb_in, right_sb_in, 
	top_cb_out, right_cb_out
);
    //clk + scan chain
    input clk, scan_clk, clb_scan_in,clb_scan_en, conn_scan_in, conn_scan_en;
    output clb_scan_out, conn_scan_out;
    //scaling singals for vertical expansion, non-scaling for horizontal 
    input [31:0] left_in, right_in;
    output [31:0] left_out, right_out;
    input [7:0] left_clb_in, right_sb_in;
    output [7:0] left_clb_out, right_cb_out; 

    //scaling signals for horizontal expansion
    input [15:0] top_in, bottom_in;
    output [15:0] top_out, bottom_out;
    input [3:0] bottom_clb_in;
    output [3:0] top_cb_out;

    //interconnect 
    wire [31:0] left_right_conn, right_left_conn;
    wire [7:0] cb_conn, sb_conn;
    wire clb_scan_conn, conn_scan_conn;

    /*ALL inputs: (Classifeid for the case of horizontal expansion)
    //Inferred
    clk, scan_clk,  
	clb_scan_en, conn_scan_en
    
    //One or the other
    clb_scan_in, clb_scan_out,
    conn_scan_in, conn_scan_out,
    left_in, right_in, 
    left_out, right_out,
    left_clb_out, right_sb_in
    left_clb_in, right_cb_out,
    
    //Change index
    top_in, bottom_in, top_out, bottom_out, bottom_clb_in, top_cb_out, */

    tile_8x2 tile_8x2_left(
        .top_in(top_in[7:0]),
        .top_out(top_out[7:0]),
		.bottom_in(bottom_in[7:0]),
		.bottom_out(bottom_out[7:0]),
        .top_cb_out(top_cb_out[1:0]),
		.bottom_clb_in(bottom_clb_in[1:0]), 
        .right_out(left_right_conn),
        .right_in(right_left_conn),
		.right_sb_in(sb_conn),
		.right_cb_out(cb_conn),
		.clb_scan_out(clb_scan_conn),   
		.conn_scan_out(conn_scan_conn), 
        .*
    );

    tile_8x2 tile_8x2_right(
        .top_in(top_in[15:8]),
        .top_out(top_out[15:8]),
		.bottom_in(bottom_in[15:8]),
		.bottom_out(bottom_out[15:8]),
        .top_cb_out(top_cb_out[3:2]),
		.bottom_clb_in(bottom_clb_in[3:2]), 
        .left_in(left_right_conn),
        .left_out(right_left_conn),
		.left_clb_out(sb_conn),
		.left_clb_in(cb_conn),
		.clb_scan_in(clb_scan_conn),   
		.conn_scan_in(conn_scan_conn),
        .* 
    );

endmodule


module tile_8x2 (
    clk, scan_clk, clb_scan_in, clb_scan_out, clb_scan_en, conn_scan_in, conn_scan_out, conn_scan_en,
    left_in, right_in, top_in, bottom_in, left_out, right_out, top_out, bottom_out, 
	left_clb_out, left_clb_in, bottom_clb_in, right_sb_in, 
	top_cb_out, right_cb_out
);
    //clk + scan chain
    input clk, scan_clk, clb_scan_in,clb_scan_en, conn_scan_in, conn_scan_en;
    output clb_scan_out, conn_scan_out;
    
    //scaling singals for vertical expansion, non-scaling for horizontal 
    input [31:0] left_in, right_in;
    output [31:0] left_out, right_out;
    input [7:0] left_clb_in, right_sb_in;
    output [7:0] left_clb_out, right_cb_out; 

    //scaling signals for horizontal expansion
    input [7:0] top_in, bottom_in;
    output [7:0] top_out, bottom_out;
    input [1:0] bottom_clb_in;
    output [1:0] top_cb_out;

    //interconnect
    wire [31:0] left_right_conn, right_left_conn;
    wire [7:0] cb_conn, sb_conn;
    wire clb_scan_conn, conn_scan_conn;
    
    /*ALL inputs: (Classifeid for the case of horizontal expansion)
    //Inferred
    clk, scan_clk,  
	clb_scan_en, conn_scan_en
    
    //One or the other
    clb_scan_in, clb_scan_out,
    conn_scan_in, conn_scan_out,
    left_in, right_in, 
    left_out, right_out,
    left_clb_out, right_sb_in
    left_clb_in, right_cb_out,
    
    //Change index
    top_in, bottom_in, top_out, bottom_out, bottom_clb_in, top_cb_out, */

    tile_8x1 tile_8x1_left(
        .top_in(top_in[3:0]),
        .top_out(top_out[3:0]),
		.bottom_in(bottom_in[3:0]),
		.bottom_out(bottom_out[3:0]),
        .top_cb_out(top_cb_out[0]),
		.bottom_clb_in(bottom_clb_in[0]), 
        .right_out(left_right_conn),
        .right_in(right_left_conn),
		.right_sb_in(sb_conn),
		.right_cb_out(cb_conn),
		.clb_scan_out(clb_scan_conn),   
		.conn_scan_out(conn_scan_conn), 
        .*
    );

    tile_8x1 tile_8x1_right(
        .top_in(top_in[7:4]),
        .top_out(top_out[7:4]),
		.bottom_in(bottom_in[7:4]),
		.bottom_out(bottom_out[7:4]),
        .top_cb_out(top_cb_out[1]),
		.bottom_clb_in(bottom_clb_in[1]), 
        .left_in(left_right_conn),
        .left_out(right_left_conn),
		.left_clb_out(sb_conn),
		.left_clb_in(cb_conn),
		.clb_scan_in(clb_scan_conn),   
		.conn_scan_in(conn_scan_conn),
        .* 
    );

endmodule
