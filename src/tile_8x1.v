`include "tile.v"

module tile_8x1 (
    clk, scan_clk, clb_scan_in, clb_scan_out, clb_scan_en, conn_scan_in, conn_scan_out, conn_scan_en, reset,
    left_in, right_in, top_in, bottom_in, left_out, right_out, top_out, bottom_out, 
	left_clb_out, left_clb_in, bottom_clb_in, right_sb_in, 
	top_cb_out, right_cb_out
);
    input clk, scan_clk, clb_scan_in, clb_scan_en, conn_scan_in,  conn_scan_en, reset;
    output clb_scan_out, conn_scan_out; 
    input [3:0] top_in, bottom_in;
    output [3:0] top_out, bottom_out;
    input bottom_clb_in;
    output top_cb_out;

    //scaling singals here
    input [31:0] left_in, right_in;
    output [31:0] left_out, right_out;
    input [7:0] left_clb_in, right_sb_in;
    output [7:0] left_clb_out, right_cb_out; 
     
    //interconnect
    wire [3:0] top_bottom_conn, bottom_top_conn;
    wire cb_conn;
    wire clb_scan_conn, conn_scan_conn;

    
    /*ALL inputs: (Classifeid for the case of vertical expansion)
    //Inferred
    clk, scan_clk,  
	clb_scan_en, conn_scan_en
    //One or the other
    clb_scan_in, clb_scan_out,
    conn_scan_in, conn_scan_out,
    bottom_clb_in, top_cb_out,
    top_in, bottom_in, 
    top_out, bottom_out,
    //Change index
    left_in, right_in, left_out, right_out, left_clb_out, left_clb_in, right_sb_in, right_cb_out,  */

    tile_4x1 tile_4x1_top(
		.left_in(left_in[15:0]),
        .left_out(left_out[15:0]),
        .left_clb_in(left_clb_in[3:0]),
        .left_clb_out(left_clb_out[3:0]),
		.right_in(right_in[15:0]),
        .right_out(right_out[15:0]),
        .right_sb_in(right_sb_in[3:0]),
		.right_cb_out(right_cb_out[3:0]),
		.bottom_in(bottom_top_conn),
		.bottom_out(top_bottom_conn),
        .bottom_clb_in(cb_conn),
		.clb_scan_out(clb_scan_conn), 
		.conn_scan_out(conn_scan_conn), 
	    .*
    );

    tile_4x1 tile_4x1_botoom(
		.left_in(left_in[31:16]),
        .left_out(left_out[31:16]),
        .left_clb_in(left_clb_in[7:4]),
        .left_clb_out(left_clb_out[7:4]),
		.right_in(right_in[31:16]),
        .right_out(right_out[31:16]),
        .right_sb_in(right_sb_in[7:4]),
		.right_cb_out(right_cb_out[7:4]),
		.top_in(top_bottom_conn),
		.top_out(bottom_top_conn),
        .top_cb_out(cb_conn),
		.clb_scan_in(clb_scan_conn), 
		.conn_scan_in(conn_scan_conn), 
	    .*
    );

endmodule

module tile_4x1 (
    clk, scan_clk, clb_scan_in, clb_scan_out, clb_scan_en, conn_scan_in, conn_scan_out, conn_scan_en, reset,
    left_in, right_in, top_in, bottom_in, left_out, right_out, top_out, bottom_out, 
	left_clb_out, left_clb_in, bottom_clb_in, right_sb_in, 
	top_cb_out, right_cb_out
);
    input clk, scan_clk, clb_scan_in, clb_scan_en, conn_scan_in,  conn_scan_en, reset;
    output clb_scan_out, conn_scan_out; 
    input [3:0] top_in, bottom_in;
    output [3:0] top_out, bottom_out;
    input bottom_clb_in;
    output top_cb_out;

    //scaling singals here
    input [15:0] left_in, right_in;
    output [15:0] left_out, right_out;
    input [3:0] left_clb_in, right_sb_in;
    output [3:0] left_clb_out, right_cb_out; 
     
    //interconnect
    wire [3:0] top_bottom_conn, bottom_top_conn;
    wire cb_conn;
    wire clb_scan_conn, conn_scan_conn;

    
    /*ALL inputs: (Classifeid for the case of vertical expansion)
    //Inferred
    clk, scan_clk,  
	clb_scan_en, conn_scan_en
    //One or the other
    clb_scan_in, clb_scan_out,
    conn_scan_in, conn_scan_out,
    bottom_clb_in, top_cb_out,
    top_in, bottom_in, 
    top_out, bottom_out,
    //Change index
    left_in, right_in, left_out, right_out, left_clb_out, left_clb_in, right_sb_in, right_cb_out,  */

    tile_2x1 tile_2x1_top(
		.left_in(left_in[7:0]),
        .left_out(left_out[7:0]),
        .left_clb_in(left_clb_in[1:0]),
        .left_clb_out(left_clb_out[1:0]),
		.right_in(right_in[7:0]),
        .right_out(right_out[7:0]),
        .right_sb_in(right_sb_in[1:0]),
		.right_cb_out(right_cb_out[1:0]),
		.bottom_in(bottom_top_conn),
		.bottom_out(top_bottom_conn),
        .bottom_clb_in(cb_conn),
		.clb_scan_out(clb_scan_conn), 
		.conn_scan_out(conn_scan_conn), 
	    .*
    );

    tile_2x1 tile_2x1_botoom(
		.left_in(left_in[15:8]),
        .left_out(left_out[15:8]),
        .left_clb_in(left_clb_in[3:2]),
        .left_clb_out(left_clb_out[3:2]),
		.right_in(right_in[15:8]),
        .right_out(right_out[15:8]),
        .right_sb_in(right_sb_in[3:2]),
		.right_cb_out(right_cb_out[3:2]),
		.top_in(top_bottom_conn),
		.top_out(bottom_top_conn),
        .top_cb_out(cb_conn),
		.clb_scan_in(clb_scan_conn), 
		.conn_scan_in(conn_scan_conn), 
	    .*
    );

endmodule

    
module tile_2x1 (
    clk, scan_clk, clb_scan_in, clb_scan_out, clb_scan_en, conn_scan_in, conn_scan_out, conn_scan_en, reset,
    left_in, right_in, top_in, bottom_in, left_out, right_out, top_out, bottom_out, 
	left_clb_out, left_clb_in, bottom_clb_in, right_sb_in, 
	top_cb_out, right_cb_out
);
    input clk, scan_clk, clb_scan_in, clb_scan_en, conn_scan_in,  conn_scan_en, reset;
    output clb_scan_out, conn_scan_out; 
    input [3:0] top_in, bottom_in;
    output [3:0] top_out, bottom_out;
    input bottom_clb_in;
    output top_cb_out;

    //scaling singals here
    input [7:0] left_in, right_in;
    output [7:0] left_out, right_out;
    input [1:0] left_clb_in, right_sb_in;
    output [1:0] left_clb_out, right_cb_out; 
    

    //interconnect 
    wire [3:0] top_bottom_conn, bottom_top_conn;
    wire cb_conn;
    wire clb_scan_conn, conn_scan_conn;

    
    /*ALL inputs: (Classifeid for the case of vertical expansion)
    //Inferred
    clk, scan_clk,  
	clb_scan_en, conn_scan_en
    //One or the other
    clb_scan_in, clb_scan_out,
    conn_scan_in, conn_scan_out,
    bottom_clb_in, top_cb_out,
    top_in, bottom_in, 
    top_out, bottom_out,
    //Change index
    left_in, right_in, left_out, right_out, left_clb_out, left_clb_in, right_sb_in, right_cb_out,  */

    tile inst_tile_top(
		.left_in(left_in[3:0]),
        .left_out(left_out[3:0]),
        .left_clb_in(left_clb_in[0]),
        .left_clb_out(left_clb_out[0]),
		.right_in(right_in[3:0]),
        .right_out(right_out[3:0]),
        .right_sb_in(right_sb_in[0]),
		.right_cb_out(right_cb_out[0]),
		.bottom_in(bottom_top_conn),
		.bottom_out(top_bottom_conn),
        .bottom_clb_in(cb_conn),
		.clb_scan_out(clb_scan_conn), 
		.conn_scan_out(conn_scan_conn), 
		.test_out_x4(),
	    .*
    );

    tile inst_tile_bottom(
		.left_in(left_in[7:4]),
        .left_out(left_out[7:4]),
        .left_clb_in(left_clb_in[1]),
        .left_clb_out(left_clb_out[1]),
		.right_in(right_in[7:4]),
        .right_out(right_out[7:4]),
        .right_sb_in(right_sb_in[1]),
		.right_cb_out(right_cb_out[1]),
		.top_in(top_bottom_conn),
		.top_out(bottom_top_conn),
        .top_cb_out(cb_conn),
		.clb_scan_in(clb_scan_conn), 
		.conn_scan_in(conn_scan_conn), 
		.test_out_x4(),
	    .*
    );

endmodule
