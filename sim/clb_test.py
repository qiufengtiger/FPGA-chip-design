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
	in_width = dut.CLB_IN_WIDTH.value
	ble_num = dut.CLB_BLE_NUM.value
	sel_width = dut.CONN_SEL_WIDTH.value
	dut._log.info("in_w=%d, #ble=%d, sel_w=%d" % (in_width, ble_num, sel_width))
	clock = Clock(dut.scan_clk, 10000, units="ps")
	cocotb.fork(clock.start())

	# test_funcs = [AND, OR, XOR, NAND, NOR, XNOR, ADD]
	test_funcs = [AND]

	is_comb_size = ble_num
	complete_bit_size = sel_width * in_width
	lut_size = 2**in_width
	# total_scan_size = complete_bit_size + is_comb_size + lut_size # 12 + 1 + 16 = 29
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

		# golden_out = [0, 0, 0, 1]
		# scan in AND bitstream
		# input_0 = A
		# input_1 = B
		# dut.in_0 <= input_0
		# ....input_1
		# dut.out.value
		# assert dut.out.value = golden_out[{B, A}]

		# [1, 0, 1, 1] etc
		# list(input_string)
		bitstream = is_comb + complete_mux_binary + test_golden_out
		total_scan_size = len(bitstream)
		print(bitstream)

		dut.scan_en <= 1
		for i in range(total_scan_size):
			# push the last value into the scan chain
			# scan in MSB first
			dut.scan_in <= bitstream.pop(-1)
			await RisingEdge(dut.scan_clk)
		dut.scan_en <= 0


		await Timer(100000, units='ps')

		for test_in, i in enumerate(input_bits):
			dut.clb_in <= test_in
			await Timer(100, units='ps')
			assert dut.out.value == test_golden_out[i], "expecting %d, getting %d" % (test_golden_out[i], dut.out.value)
			