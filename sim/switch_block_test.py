import random
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import FallingEdge
from cocotb.triggers import RisingEdge
from cocotb.triggers import Timer
from cocotb.binary import BinaryValue
import os

# convert int list to binary list, in reversed order for scanning
# example: [2, 0, 1, 3] -> [0, 1, 0, 0, 1, 0, 1, 1]
def int_list_to_bitstream(input_list, bit_length):
	format_string = "{0:0%db}" % bit_length
	binary = [format_string.format(item) for item in input_list]
	binary = [list(item)[::-1] for item in binary]
	binary = sum(binary, [])
	binary = [int(item) for item in binary]
	return binary

@cocotb.test()
async def test_sb(dut):
	clock = Clock(dut.clk, 10000, units="ps")
	cocotb.fork(clock.start())

	width = dut.CHANNEL_ONEWAY_WIDTH.value.integer
	dut._log.info("Found SB with channel oneway width %d" % (width))

	# random config generation
	left_select = [random.randint(0, 2) for i in range(3)]
	left_select.append(random.randint(0, 3))
	right_select = [random.randint(0, 2) for i in range(3)]
	right_select.append(random.randint(0, 3))
	top_select = [random.randint(0, 2) for i in range(4)]
	bottom_select = [random.randint(0, 2) for i in range(4)]

	left_binary = int_list_to_bitstream(left_select, 2)
	right_binary = int_list_to_bitstream(right_select, 2)
	top_binary = int_list_to_bitstream(top_select, 2)
	bottom_binary = int_list_to_bitstream(bottom_select, 2)

	# random input generation
	left_in = random.randint(0, 2 ** width - 1)
	right_in = random.randint(0, 2 ** width - 1)
	top_in = random.randint(0, 2 ** width - 1)
	bottom_in = random.randint(0, 2 ** width - 1)
	left_clb_in = random.randint(0, 1)
	right_clb_in = random.randint(0, 1)

	bitstream = left_binary + right_binary + top_binary + bottom_binary;
	total_scan_size = len(bitstream)

	print(bitstream)

	# scan in config
	dut.scan_en <= 1
	for i in range(total_scan_size):
		# push the last value into the scan chain
		# scan in MSB first
		dut.scan_in <= bitstream.pop(-1)
		await RisingEdge(dut.clk)
	dut.scan_en <= 0

	# input
	dut.left_in <= left_in
	dut.right_in <= right_in
	dut.top_in <= top_in
	dut.bottom_in <= bottom_in
	dut.left_clb_in <= left_clb_in
	dut.right_clb_in <= right_clb_in

	await Timer(100, units='ps')

	left_out = dut.left_out.value
	right_out = dut.right_out.value
	top_out = dut.top_out.value
	bottom_out = dut.bottom_out.value

	left_out.big_endian = False
	right_out.big_endian = False
	top_out.big_endian = False
	bottom_out.big_endian = False

	# convert int to cocotb BinaryValue for easy bit select
	left_in = BinaryValue(left_in, n_bits=4, bigEndian=False)
	right_in = BinaryValue(right_in, n_bits=4, bigEndian=False)
	top_in = BinaryValue(top_in, n_bits=4, bigEndian=False)
	bottom_in = BinaryValue(bottom_in, n_bits=4, bigEndian=False)

	# golden result
	left_out_dict_0 = {0: bottom_in[2], 1: top_in[1], 2: right_in[0]}
	left_out_dict_1 = {0: bottom_in[1], 1: top_in[2], 2: right_in[1]}
	left_out_dict_2 = {0: bottom_in[0], 1: top_in[3], 2: right_in[2]}
	left_out_dict_3 = {0: bottom_in[3], 1: top_in[0], 2: right_in[3], 3: left_clb_in}
	
	assert left_out[0] == left_out_dict_0[left_select[0]], "left_out[0] expecting %d, getting %d" % (left_out_dict_0[left_select[0]], left_out[0])
	assert left_out[1] == left_out_dict_1[left_select[1]], "left_out[1] expecting %d, getting %d" % (left_out_dict_1[left_select[1]], left_out[1])
	assert left_out[2] == left_out_dict_2[left_select[2]], "left_out[2] expecting %d, getting %d" % (left_out_dict_2[left_select[2]], left_out[2])
	assert left_out[3] == left_out_dict_3[left_select[3]], "left_out[3] expecting %d, getting %d" % (left_out_dict_3[left_select[3]], left_out[3])

	right_out_dict_0 = {0: bottom_in[3], 1: top_in[2], 2: left_in[0]}
	right_out_dict_1 = {0: bottom_in[0], 1: top_in[1], 2: left_in[1]}
	right_out_dict_2 = {0: bottom_in[1], 1: top_in[0], 2: left_in[2]}
	right_out_dict_3 = {0: bottom_in[2], 1: top_in[3], 2: left_in[3], 3: right_clb_in}

	assert right_out[0] == right_out_dict_0[right_select[0]], "right_out[0] expecting %d, getting %d" % (right_out_dict_0[right_select[0]], right_out[0])
	assert right_out[1] == right_out_dict_1[right_select[1]], "right_out[1] expecting %d, getting %d" % (right_out_dict_1[right_select[1]], right_out[1])
	assert right_out[2] == right_out_dict_2[right_select[2]], "right_out[2] expecting %d, getting %d" % (right_out_dict_2[right_select[2]], right_out[2])
	assert right_out[3] == right_out_dict_3[right_select[3]], "right_out[3] expecting %d, getting %d" % (right_out_dict_3[right_select[3]], right_out[3])

	top_out_dict_0 = {0: bottom_in[0], 1: right_in[2], 2: left_in[3]}
	top_out_dict_1 = {0: bottom_in[1], 1: right_in[1], 2: left_in[0]}
	top_out_dict_2 = {0: bottom_in[2], 1: right_in[0], 2: left_in[1]}
	top_out_dict_3 = {0: bottom_in[3], 1: right_in[3], 2: left_in[2]}

	assert top_out[0] == top_out_dict_0[top_select[0]], "top_out[0] expecting %d, getting %d" % (top_out_dict_0[top_select[0]], top_out[0])
	assert top_out[1] == top_out_dict_1[top_select[1]], "top_out[1] expecting %d, getting %d" % (top_out_dict_1[top_select[1]], top_out[1])
	assert top_out[2] == top_out_dict_2[top_select[2]], "top_out[2] expecting %d, getting %d" % (top_out_dict_2[top_select[2]], top_out[2])
	assert top_out[3] == top_out_dict_3[top_select[3]], "top_out[3] expecting %d, getting %d" % (top_out_dict_3[top_select[3]], top_out[3])

	bottom_out_dict_0 = {0: top_in[0], 1: right_in[1], 2: left_in[2]}
	bottom_out_dict_1 = {0: top_in[1], 1: right_in[2], 2: left_in[1]}
	bottom_out_dict_2 = {0: top_in[2], 1: right_in[3], 2: left_in[0]}
	bottom_out_dict_3 = {0: top_in[3], 1: right_in[0], 2: left_in[3]}

	assert bottom_out[0] == bottom_out_dict_0[bottom_select[0]], "bottom_out[0] expecting %d, getting %d" % (bottom_out_dict_0[bottom_select[0]], bottom_out[0])
	assert bottom_out[1] == bottom_out_dict_1[bottom_select[1]], "bottom_out[1] expecting %d, getting %d" % (bottom_out_dict_1[bottom_select[1]], bottom_out[1])
	assert bottom_out[2] == bottom_out_dict_2[bottom_select[2]], "bottom_out[2] expecting %d, getting %d" % (bottom_out_dict_2[bottom_select[2]], bottom_out[2])
	assert bottom_out[3] == bottom_out_dict_3[bottom_select[3]], "bottom_out[3] expecting %d, getting %d" % (bottom_out_dict_3[bottom_select[3]], bottom_out[3])





