import getopt
import sys
sys.path.insert(0, './sim/')
import helper

# default configs
bitstream_directory = './bitstream/'
default_module = 'blink'
clb_bitstream_file = default_module + '_clb.bitstream'
clb_bitstream = []
route_bitstream_file = default_module + '_blink.bitstream'
route_bitstream = []

# verification
clb_bitstream_length = 1856
route_bitstream_length = 3168

# result tb config
tb_directory = './'
tb_file_name = 'tb.v'
tb_file_dir = ''
tb_head = ''
tb_body = ''

def format_tb_head():
	global tb_head
	module_name = tb_file_name.split('.')[0]
	tb_head = 'module ' + module_name + '();\n'
	tb_head += '\treg clk = 0;\n\treg scan_clk = 0;\n\treg reset = 0;\n\treg clb_scan_in, clb_scan_en, conn_scan_in, conn_scan_en;\n\n'
	tb_head += '\twire clb_scan_out, conn_scan_out;\n'
	tb_head += '\twire [19:0] fpga_in, fpga_out;\n\n'
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
	tb_head += '\tinitial begin\n'
	tb_head += '\t\t$dumpfile(\"' + module_name + '.vcd\");\n'
	tb_head += '\t\t$dumpvars(0, ' + module_name + ');\n'
	tb_head += '\t\t$dumpon;\n\n'

def format_tb_body():
	global tb_body
	body_front = '\t\t#10 '
	tb_body = body_front + 'clb_scan_en <= 1; clb_scan_in <= 1\'b' + clb_bitstream[0] + ';\n'
	
	for clb_bit in clb_bitstream[1:]:
		tb_body += body_front + 'clb_scan_in <= 1\'b' + clb_bit + ';\n'
	tb_body += body_front + 'clb_scan_en <= 0\n'

def write_tb():
	global tb_file_dir
	tb_file_dir = tb_directory + tb_file_name
	with open(tb_file_dir, 'w') as tb_file:
		tb_file.write(tb_head)
		tb_file.write(tb_body)

def read_clb_bitstream():
	global clb_bitstream
	clb_bitstream_file_dir = bitstream_directory + clb_bitstream_file
	with open(clb_bitstream_file_dir, 'r') as clb_file:
		clb_bitstream = list(clb_file.readline()) 

def read_route_bitstream():
	global route_bitstream
	route_bitstream_file_dir = bitstream_directory + route_bitstream_file
	with open(route_bitstream_file_dir, 'r') as route_file:
		lines = route_file.readlines()
		for line in lines:
			route_bitstream += helper.int_list_to_bitstream([int(line)], 2)

if __name__=="__main__":
	try:
		opts, args = getopt.getopt(sys.argv[1:], 'c:r:o:', ['clb=', 'route=', 'output='])
	except getopt.GetoptError:
		print('bitstream_to_tb.py -c <clb.bitstream> -r <route.bitstream>')
		sys.exit(2)
	for opt, arg in opts:
		if opt in ['-c', '--clb']:
			clb_bitstream_file = arg
		elif opt in ['-r', '--route']:
			route_bitstream_file = arg
		elif opt in ['-o', '--output']:
			tb_file_name = arg
		else:
			print('unknown arg: %s' % (opt))
			sys.exit(2)

	read_clb_bitstream()
	read_route_bitstream()

	assert clb_bitstream_length == len(clb_bitstream), 'clb_bitstream length incorrect'
	assert route_bitstream_length == len(route_bitstream), 'route_bitstream length incorrect'
	print('read bitstream complete')

	format_tb_head()
	print('format tb head complete')

	format_tb_body()
	print('format tb body complete')

	write_tb()
	print('tb written to %s' % (tb_file_dir))







