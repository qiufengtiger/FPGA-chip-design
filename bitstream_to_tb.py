import getopt
import sys
sys.path.insert(0, './sim/')
import helper

# default configs
# bitstream_directory = 'Cozy_Benchmarks_Bitstreams/'
default_module = 'blink'
clb_bitstream_filepath = 'bitstream/' + default_module + '.clb.bitstream'
clb_bitstream = []
route_bitstream_filepath = 'bitstream/' + default_module + '.route.bitstream'
route_bitstream = []

# verification
clb_bitstream_length = 1856
route_bitstream_length = 3168 + 20 # 20 more io config bits

# result tb config
# tb_directory = 'Cocotb8x8/src/'
tb_filepath = 'src/tb.v'
# tb_file_dir = ''
tb_head = ''
tb_body = ''
tb_tail = ''
tb_test_inspect_time = 200

# tb input config
tb_conf_filepath = 'bitstream/'+default_module+'.conf'
# tb_conf_file_dir = 'Cozy_Benchmarks/'
tb_conf = []
tb_IO_conf = ''

generatingForChipSV = False

def format_tb_head_chip():
    global tb_head
    
    module_name = tb_filepath.split('/')[-1].split('.')[0]
    tb_head = 'module ' + module_name + '();\n'
    
    
    tb_head += '''
	reg clk = 0;
	reg scan_clk = 0;
	reg reset = 0;
	reg clb_scan_in, clb_scan_en, conn_scan_in, conn_scan_en;

	reg start_fpga_clk = 0;	wire clb_scan_out, conn_scan_out;
	wire [19:0] fpga_io;
    '''
    tb_head += tb_IO_conf
    
    tb_head += '''
    reg [19:0] fpga_input=20'h0;
    
    genvar i;
	generate
		for(i = 0; i < 20; i = i + 1) begin
			assign fpga_io[i] = is_fpga_input[i] ? fpga_input[i] : 1'bz;
		end
	endgenerate
    
    //assign fpga_io[14] = tristate ? fpga_reset_in : 1'bz;
    
    chip inst_chip(
		.clk(clk),
		.scan_clk(scan_clk),
		.fpga_io(fpga_io),
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
		$dumpfile("tb.vcd");
		$dumpvars(0, tb);
    '''

def format_tb_head():
    sssss = '''always @(*) begin
		if (start_fpga_clk)
			clk = scan_clk;
		else
			clk = 0;
	end'''
    global tb_head
    module_name = tb_filepath.split('/')[-1].split('.')[0]
    # tb_head = '`include "fpga_core.v"\n\n'
    tb_head = 'module ' + module_name + '();\n'
    tb_head += '\treg clk = 0;\n\treg scan_clk = 0;\n\treg reset = 0;\n\treg clb_scan_in, clb_scan_en, conn_scan_in, conn_scan_en;\n\n'
    tb_head += '\treg start_fpga_clk = 0;'
    tb_head += '\twire clb_scan_out, conn_scan_out;\n'
    tb_head += '\treg [19:0] fpga_in = 0;\n\twire [19:0] fpga_out;\n\n'
    tb_head += '\tfpga_core inst_test_fpga_core(\n\t\t.clk(clk),\n\t\t.scan_clk(scan_clk),\n\t\t.fpga_in(fpga_in),\n\t\t.fpga_out(fpga_out),\n\t\t'
    tb_head += '.clb_scan_in(clb_scan_in),\n\t\t.clb_scan_out(clb_scan_out),\n\t\t.clb_scan_en(clb_scan_en),\n\t\t'
    tb_head += '.conn_scan_in(conn_scan_in),\n\t\t.conn_scan_out(conn_scan_out),\n\t\t.conn_scan_en(conn_scan_en),\n\t\t'
    tb_head += '.reset(reset)\n\t);\n\n'
    tb_head += '\tinitial begin\n'
    tb_head += '\t\tclk = 0; scan_clk = 0; reset = 0; clb_scan_in = 0; clb_scan_en = 0; conn_scan_in = 0; conn_scan_en = 0;\n'
    tb_head += '\tend\n\n'
    tb_head += '\talways begin\n'
    tb_head += '\t\t#5 scan_clk = ~scan_clk;\n'
    tb_head += '\tend\n'
    tb_head += sssss
    tb_head += '\tinitial begin\n'
    tb_head += '\t\t$dumpfile(\"' + module_name + '.vcd\");\n'
    tb_head += '\t\t$dumpvars(0, ' + module_name + ');\n'
    # tb_head += '\t\t$dumpon;\n\n'

def format_tb_body():
    global tb_body
    body_front = '\t\t#10 '
    tb_body = body_front + 'clb_scan_en <= 1; clb_scan_in <= 1\'b' + clb_bitstream[0] + ';\n'
    for clb_bit in clb_bitstream[1:]:
        tb_body += body_front + 'clb_scan_in <= 1\'b' + clb_bit + ';\n'
    tb_body += body_front + 'clb_scan_en <= 0;\n'
    tb_body += body_front + 'conn_scan_en <= 1; conn_scan_in <= 1\'b' + route_bitstream[0] + ';\n'
    for route_bit in route_bitstream[1:]:
        tb_body += body_front + 'conn_scan_in <= 1\'b' + route_bit + ';\n'
    tb_body += body_front + 'conn_scan_en <= 0; start_fpga_clk <= 1;\n'
    tb_body += body_front + 'reset <= 1;\n'
    tb_body += body_front + 'reset <= 0;\n'
    
def format_tb_tail():
    global tb_tail
    total_length = (len(clb_bitstream) + len(route_bitstream)) * 10 + tb_test_inspect_time
    tb_tail = ''
    for conf_line in tb_conf:
        tb_tail += '\t\t'+conf_line + ' '
    tb_tail += '\n'
    tb_tail += '\t\t#' + str(total_length) + ' $finish;\n'
    tb_tail += '\t end\n'
    tb_tail += 'endmodule'

def write_tb():
    # global tb_file_dir
    # tb_file_dir = tb_directory + tb_file_name
    with open(tb_filepath, 'w') as tb_file:
        tb_file.write(tb_head)
        tb_file.write(tb_body)
        tb_file.write(tb_tail)

def read_clb_bitstream():
    global clb_bitstream
    clb_bitstream_file_dir = clb_bitstream_filepath
    with open(clb_bitstream_file_dir, 'r') as clb_file:
        clb_bitstream = list(clb_file.readline())
    clb_bitstream = clb_bitstream[::-1]

def read_route_bitstream():
    global route_bitstream
    route_bitstream_file_dir = route_bitstream_filepath
    with open(route_bitstream_file_dir, 'r') as route_file:
        lines = route_file.readlines()
        for line, index in zip(lines, range(len(lines))):
            if index < len(lines) - 20:
                route_bitstream += helper.int_list_to_bitstream([int(line)], 2)
            else:
                route_bitstream += [int(line)]
    route_bitstream = [str(x) for x in route_bitstream]
    route_bitstream = route_bitstream[::-1]

def read_conf():
    global tb_conf
    global tb_IO_conf
    tb_conf_file_path = tb_conf_filepath
    with open(tb_conf_file_path, 'r') as conf_file:
        tb_conf = conf_file.readlines()
    temp = []
    IOMode = False
    for configLine in tb_conf:
        if configLine == "TBIO BEGIN\n":
            IOMode = True
        elif configLine == "TBIO END\n":
            IOMode = False
        elif IOMode:
            tb_IO_conf = configLine
        else:
            temp += [configLine]
    tb_conf = temp

# format:
# python bitstream_to_tb.py -c <clb.bitstream> -r <route.bitstream> -o <output.v> -i <input.conf>
# see the top configs for the search directory
# clb.bitstream: clb bitstream, follows Tong's script format
# route.bitstream: SB and CB bitstream, follows Tong's script format
# output: name of target output verilog tb
# input.conf: contains all the input to module after bitstream scan in is complete, in verilog format
if __name__=="__main__":
    try:
        opts, args = getopt.getopt(sys.argv[1:], 'c:r:o:i:m:', ['clb=', 'route=', 
                                                                'output=', 'input=', 
                                                                'module=', 'isChip'])
    except getopt.GetoptError:
        print('bitstream_to_tb.py -c <clb.bitstream> -r <route.bitstream> -o <output.v> -i <input.conf>')
        sys.exit(2)
    for opt, arg in opts:
        if opt in ['-c', '--clb']:
            clb_bitstream_filepath = arg
        elif opt in ['-r', '--route']:
            route_bitstream_filepath = arg
        elif opt in ['-o', '--output']:
            tb_filepath = arg
        elif opt in ['-i', '--input']:
            tb_conf_filepath = arg
        elif opt in ['--isChip']:
            generatingForChipSV = True
        elif opt in ['-m', '--module']:
            print("loading benchmark module "+str(arg))
            clb_bitstream_filepath = 'bitstream/' + str(arg) + '.clb.bitstream'
            route_bitstream_filepath = 'bitstream/' + str(arg) + '.route.bitstream'
            tb_conf_filepath = 'bitstream/'+str(arg)+'.conf'
            
        else:
            print('unknown arg: %s' % (opt))
            sys.exit(2)

    read_clb_bitstream()
    read_route_bitstream()

    assert clb_bitstream_length == len(clb_bitstream), 'clb_bitstream length incorrect'
    assert route_bitstream_length == len(route_bitstream), 'route_bitstream length incorrect'
    print('read bitstream complete')
    
    read_conf()
    print('tb input conf read: %s' % (tb_conf_filepath))
    
    if generatingForChipSV:
        format_tb_head_chip()
    else:
        format_tb_head()
    print('format tb head complete')

    format_tb_body()
    print('format tb body complete')

    format_tb_tail()
    print('format tb tail complete')

    write_tb()
    print('tb written to %s' % (tb_filepath))







