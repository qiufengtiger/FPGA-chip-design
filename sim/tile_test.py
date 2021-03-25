import random
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import FallingEdge
from cocotb.triggers import RisingEdge
from cocotb.triggers import Timer
from cocotb.binary import BinaryValue
from helper import int_list_to_bitstream
from helper import bin_list_to_int_little_endian
import os

@cocotb.test()
async def test_tile(dut):
	clock = Clock(dut.clk, 10000, units="ps")
	cocotb.fork(clock.start())

	# read param
	channel_oneway_width = dut.CHANNEL_ONEWAY_WIDTH.value
	ble_num = dut.CLB_BLE_NUM.value
	conn_sel_width = dut.CONN_SEL_WIDTH.value

	dut._log.info("Found CB with COW: %d, #BLE: %d, CSW: %d" % (channel_oneway_width, ble_num, conn_sel_width))

	# generate and scan in random clb config
	lut_binary = [random.randint(0, 1) for i in range(2**channel_oneway_width)]
	complete_config = [random.randint(0, 3) for i in range(channel_oneway_width)]
	# complete_config = [0, 1, 2, 3]
	complete_binary = int_list_to_bitstream(complete_config, 3)
	is_comb = [1]
	clb_bitstream = is_comb + complete_binary + lut_binary
	clb_scan_size = len(clb_bitstream)

	print("clb bitstream")
	print("length: %d" % clb_scan_size)
	print(clb_bitstream)

	dut.clb_scan_en <= 1
	for i in range(clb_scan_size):
		dut.clb_scan_in <= clb_bitstream.pop(-1)
		await RisingEdge(dut.clk)
	dut.clb_scan_en <= 0

	# generate and scan in conn config
	sb_left_select = [random.randint(0, 2) for i in range(3)]
	sb_left_select.append(random.randint(0, 3))
	sb_right_select = [random.randint(0, 2) for i in range(3)]
	sb_right_select.append(random.randint(0, 3))
	sb_top_select = [random.randint(0, 2) for i in range(4)]
	sb_bottom_select = [random.randint(0, 2) for i in range(4)]
	# convert to bitstream
	sb_left_binary = int_list_to_bitstream(sb_left_select, 2)
	sb_right_binary = int_list_to_bitstream(sb_right_select, 2)
	sb_top_binary = int_list_to_bitstream(sb_top_select, 2)
	sb_bottom_binary = int_list_to_bitstream(sb_bottom_select, 2)
	# cb config & bitstream
	cb_0_config = [random.randint(0, 3) for i in range(2)]
	cb_0_binary = int_list_to_bitstream(cb_0_config, 2)
	cb_1_config = [random.randint(0, 3) for i in range(2)]
	cb_1_binary = int_list_to_bitstream(cb_1_config, 2)

	conn_bitstream = sb_left_binary + sb_right_binary + sb_top_binary + sb_bottom_binary + cb_0_binary + cb_1_binary
	conn_scan_size = len(conn_bitstream)

	print("conn bitstream")
	print("length: %d" % conn_scan_size)
	print(conn_bitstream)

	dut.conn_scan_en <= 1
	for i in range(conn_scan_size):
		dut.conn_scan_in <= conn_bitstream.pop(-1)
		await RisingEdge(dut.clk)
	dut.conn_scan_en <= 0

	# random input generation
	left_in = random.randint(0, 2 ** channel_oneway_width - 1)
	right_in = random.randint(0, 2 ** channel_oneway_width - 1)
	top_in = random.randint(0, 2 ** channel_oneway_width - 1)
	bottom_in = random.randint(0, 2 ** channel_oneway_width - 1)
	left_clb_in = random.randint(0, 1)
	bottom_clb_in = random.randint(0, 1)
	right_sb_in = random.randint(0, 1)

	# input to dut
	dut.left_in <= left_in
	dut.right_in <= right_in
	dut.top_in <= top_in
	dut.bottom_in <= bottom_in
	dut.left_clb_in <= left_clb_in
	dut.bottom_clb_in <= bottom_clb_in
	dut.right_sb_in <= right_sb_in

	await Timer(100, units='ps')

	# verification
	# first check if clb out matches lut result
	clb_in_actual = dut.test_out_x4.value
	clb_in_actual.big_endian = False
	clb_out_actual = dut.left_clb_out.value
	lut_binary_actual = [clb_in_actual[complete_config[0]], clb_in_actual[complete_config[1]], clb_in_actual[complete_config[2]], clb_in_actual[complete_config[3]]]
	lut_in_actual = bin_list_to_int_little_endian(lut_binary_actual)
	assert clb_out_actual == lut_binary[lut_in_actual], "clb out expecting %d, getting %d" % (lut_binary[lut_in_actual], clb_out_actual)

	# check if cb and sb are working properly
	# convert int to cocotb BinaryValue for easy bit select
	left_in = BinaryValue(left_in, n_bits=4, bigEndian=False)
	right_in = BinaryValue(right_in, n_bits=4, bigEndian=False)
	top_in = BinaryValue(top_in, n_bits=4, bigEndian=False)
	bottom_in = BinaryValue(bottom_in, n_bits=4, bigEndian=False)

	# dictionary for finding golden sb out, index is arbitrary arch design
	left_out_dict_0 = {0: bottom_in[2], 1: top_in[1], 2: right_in[0]}
	left_out_dict_1 = {0: bottom_in[1], 1: top_in[2], 2: right_in[1]}
	left_out_dict_2 = {0: bottom_in[0], 1: top_in[3], 2: right_in[2]}
	left_out_dict_3 = {0: bottom_in[3], 1: top_in[0], 2: right_in[3], 3: clb_out_actual.integer}
	
	right_out_dict_0 = {0: bottom_in[3], 1: top_in[2], 2: left_in[0]}
	right_out_dict_1 = {0: bottom_in[0], 1: top_in[1], 2: left_in[1]}
	right_out_dict_2 = {0: bottom_in[1], 1: top_in[0], 2: left_in[2]}
	right_out_dict_3 = {0: bottom_in[2], 1: top_in[3], 2: left_in[3], 3: right_sb_in}

	top_out_dict_0 = {0: bottom_in[0], 1: right_in[2], 2: left_in[3]}
	top_out_dict_1 = {0: bottom_in[1], 1: right_in[1], 2: left_in[0]}
	top_out_dict_2 = {0: bottom_in[2], 1: right_in[0], 2: left_in[1]}
	top_out_dict_3 = {0: bottom_in[3], 1: right_in[3], 2: left_in[2]}

	bottom_out_dict_0 = {0: top_in[0], 1: right_in[1], 2: left_in[2]}
	bottom_out_dict_1 = {0: top_in[1], 1: right_in[2], 2: left_in[1]}
	bottom_out_dict_2 = {0: top_in[2], 1: right_in[3], 2: left_in[0]}
	bottom_out_dict_3 = {0: top_in[3], 1: right_in[0], 2: left_in[3]}

	# create sb golden out
	left_out_golden = [left_out_dict_0[sb_left_select[0]], left_out_dict_1[sb_left_select[1]], left_out_dict_2[sb_left_select[2]], left_out_dict_3[sb_left_select[3]]]
	right_out_golden = [right_out_dict_0[sb_right_select[0]], right_out_dict_1[sb_right_select[1]], right_out_dict_2[sb_right_select[2]], right_out_dict_3[sb_right_select[3]]]
	top_out_golden = [top_out_dict_0[sb_top_select[0]], top_out_dict_1[sb_top_select[1]], top_out_dict_2[sb_top_select[2]], top_out_dict_3[sb_top_select[3]]]
	bottom_out_golden = [bottom_out_dict_0[sb_bottom_select[0]], bottom_out_dict_1[sb_bottom_select[1]], bottom_out_dict_2[sb_bottom_select[2]], bottom_out_dict_3[sb_bottom_select[3]]]
	# get actual sb out in int
	left_out_actual = dut.left_out.value.integer
	right_out_actual = dut.right_out.value.integer
	top_out_actual = dut.top_out.value.integer
	bottom_out_actual = dut.bottom_out.value.integer

	# compare golden out and actual out
	assert left_out_actual == bin_list_to_int_little_endian(left_out_golden), "left out expecting %d, getting %d" % (bin_list_to_int_little_endian(left_out_golden), left_out_actual)
	assert right_out_actual == bin_list_to_int_little_endian(right_out_golden), "right out expecting %d, getting %d" % (bin_list_to_int_little_endian(right_out_golden), right_out_actual)
	assert top_out_actual == bin_list_to_int_little_endian(top_out_golden), "top out expecting %d, getting %d" % (bin_list_to_int_little_endian(top_out_golden), top_out_actual)
	assert bottom_out_actual == bin_list_to_int_little_endian(bottom_out_golden), "bottom out expecting %d, getting %d" % (bin_list_to_int_little_endian(bottom_out_golden), bottom_out_actual)

	# diectionary for finding golden cb out
	# cb_<cb inst id>_dict_<bit id>
	cb_0_dict_0 = {0: left_out_golden[0], 1: left_in[0], 2: left_out_golden[2], 3: left_in[2]}
	cb_0_dict_1 = {0: left_out_golden[1], 1: left_in[1], 2: left_out_golden[3], 3: left_in[3]}
	cb_1_dict_0 = {0: bottom_in[0], 1: bottom_out_golden[0], 2: bottom_in[2], 3: bottom_out_golden[2]}
	cb_1_dict_1 = {0: bottom_in[1], 1: bottom_out_golden[1], 2: bottom_in[3], 3: bottom_out_golden[3]}
	# cb golden out
	cb_0_golden = [cb_0_dict_0[cb_0_config[0]], cb_0_dict_1[cb_0_config[1]]]
	cb_1_golden = [cb_1_dict_0[cb_1_config[0]], cb_1_dict_1[cb_1_config[1]]]

	# cb_0_0 to clb_in[2] in the tile above
	assert dut.top_cb_out.value == cb_0_golden[0], "cb_0_0 expecting %d, getting %d" % (cb_0_golden[0], dut.top_cb_out.value)
	# cb_0_1 to clb_in[0] in this tile
	assert clb_in_actual[0] == cb_0_golden[1], "cb_0_1 expecting %d, getting %d" % (cb_0_golden[1], clb_in_actual[0])
	# cb_1_0 to clb_in[1] in this tile
	assert clb_in_actual[1] == cb_1_golden[0], "cb_1_0 expecting %d, getting %d" % (cb_1_golden[0], clb_in_actual[1])
	# cb_1_1 to clb_in[3] in the tile to the right
	assert dut.right_cb_out == cb_1_golden[1], "cb_1_1 expecting %d, getting %d" % (cb_1_golden[1], dut.right_cb_out)



