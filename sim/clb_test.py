import random
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import FallingEdge
from cocotb.triggers import RisingEdge
from cocotb.triggers import Timer
import os

AND = 0
OR = 1
XOR = 2
NAND = 3
NOR = 4
XNOR = 5
ADD = 6

@cocotb.test()
async def test_clb(dut):
	in_width = dut.CLB_IN_WIDTH.value.integer
	ble_num = dut.CLB_BLE_NUM.value.integer
	sel_width = dut.CONN_SEL_WIDTH.value.integer
	dut._log.info("in_w=%d, #ble=%d, sel_w=%d" % (in_width, ble_num, sel_width))
	clock = Clock(dut.clk, 10000, units="ps")
	cocotb.fork(clock.start())

	test_funcs = [AND, OR, XOR, NAND, NOR, XNOR, ADD]

	is_comb_size = ble_num
	complete_bit_size = sel_width * in_width
	lut_size = 2**in_width
	total_scan_size = complete_bit_size + is_comb_size + lut_size # 12 + 1 + 16 = 29
	is_comb = [1]
	# direct conn
	complete_mux = [0, 1, 2, 3]
	complete_mux_binary = ["{0:03b}".format(item) for item in complete_mux]
	complete_mux_binary = [list(item)[::-1] for item in complete_mux_binary]
	# this is the bitstream for mux config
	# scan in MSB first
	complete_mux_binary = sum(complete_mux_binary, [])
	complete_mux_binary = [int(item) for item in complete_mux_binary]
	input_bits = list(range(0, 2**in_width));
	input_bits_binary = ["{0:04b}".format(item) for item in input_bits]
	input_bits_binary = [list(item)[::-1] for item in input_bits_binary]

	for test_func in test_funcs:
		test_golden_out = []
		# test_golden_out here is in fact the bitstream writing to lut
		for sample_input in input_bits_binary:
			in_0 = int(sample_input[0], 2)
			in_1 = int(sample_input[1], 2)
			in_2 = int(sample_input[2], 2)
			in_3 = int(sample_input[3], 2)
			this_golden_out = 0;
			if test_func is AND:
				this_golden_out = in_0 & in_1 & in_2 & in_3
			elif test_func is OR:
				this_golden_out = in_0 | in_1 | in_2 | in_3			
			elif test_func is XOR:
				this_golden_out = in_0 ^ in_1 ^ in_2 ^ in_3	
			elif test_func is NAND:
				this_golden_out = 0 if (in_0 & in_1 & in_2 & in_3 == 1) else 1
			elif test_func is NOR:
				this_golden_out = 0 if (in_0 | in_1 | in_2 | in_3 == 1) else 1
			elif test_func is XNOR:
				this_golden_out = 0 if (in_0 ^ in_1 ^ in_2 ^ in_3 == 1) else 1
			elif test_func is ADD:
				this_golden_out = (in_0 + in_1 + in_2 + in_3) & 1
			test_golden_out.append(this_golden_out)


		bitstream = is_comb + complete_mux_binary + test_golden_out
		print(bitstream)

		dut.scan_en <= 1
		for i in range(total_scan_size):
			# push the last value into the scan chain
			# scan in MSB first
			dut.scan_in <= bitstream.pop(-1)
			await RisingEdge(dut.clk)
		dut.scan_en <= 0


		await Timer(100000, units='ps')

		for test_in, i in enumerate(input_bits):
			dut.clb_in <= test_in
			await Timer(100, units='ps')
			assert dut.out.value == test_golden_out[i], "expecting %d, getting %d" % (test_golden_out[i], dut.out.value)




	# testSize = sel_width * out_width
	# print(addr_width)
	# initialization
	# testMuxSel = []
	# for i in range(out_width):
	# 	testMuxSel.append(random.randint(0, in_width - 1))
	# convert int to binary array for scan in
	# testMuxSelBinary = ["{0:03b}".format(item) for item in testMuxSel]
	# testMuxSelBinary = [list(item) for item in testMuxSelBinary]
	# testMuxSelBit = sum(testMuxSelBinary, [])
	# testMuxSelBit = [int(bit) for bit in testMuxSelBit]
	# # MSB -> LSB
	# testMuxSelBit.reverse();
	# print(testMuxSelBit)
	# for i in range(sel_width * out_width):
	# 	# push the last value into the scan chain
	# 	# scan in MSB first
	# 	dut.scan_in <= testMuxSelBit.pop(-1)
	# 	dut.scan_en <= 1
	# 	await RisingEdge(dut.clk)
	# 	dut.scan_en <= 0

	# await Timer(100000, units='ps')

	# print(dut.config_test.value)
	# print(dut.c1.value)

	# # test in gen
	# testIn = []
	# for i in range(in_width):
	# 	testIn.append(random.randint(0, 1))
	# # for i in range(0, (2**sel_width - in_width)):
	# # 	testIn.append(0) 

	# # test golden out gen
	# testGoldenOut = [0] * out_width
	# for i in range(out_width):
	# 	# print(int("".join(str(item) for item in testMuxSel[3 * i : 3 * i + 3]), 2))
	# 	# testGoldenOut[i] = testIn[int("".join(str(item) for item in testMuxSel[3 * i : 3 * i + 3]), 2)]
	# 	testGoldenOut[i] = testIn[testMuxSel[i]]

	
	# print(testMuxSel)
	# print(testIn)
	# print(testGoldenOut)
	# # testIn.reverse()
	# # print(int("".join(str(bit) for bit in testIn), 2))

	# result = []
	# # result2 = []
	# testIn.reverse()
	# dut.complete_in <= int("".join(str(bit) for bit in testIn), 2)
	# await Timer(100, units='ps')
	# result.append(dut.out.value)
	# # assert testValues[i] == dut.rdata.value
	# print(result)