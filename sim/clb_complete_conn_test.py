import random
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import FallingEdge
from cocotb.triggers import RisingEdge
from cocotb.triggers import Timer
import os

@cocotb.test()
async def test_complete_conn(dut):
	in_width = dut.IN_WIDTH.value.integer
	out_width = dut.OUT_WIDTH.value.integer
	sel_width = dut.MUX_SEL_WIDTH.value.integer
	dut._log.info("in_w=%d, out_w=%d, sel_w=%d" % (in_width, out_width, sel_width))
	clock = Clock(dut.clk, 10000, units="ps")
	cocotb.fork(clock.start())

	# testSize = sel_width * out_width
	# print(addr_width)
	# initialization
	test_mux_sel = []
	for i in range(out_width):
		test_mux_sel.append(random.randint(0, in_width - 1))
	# convert int to binary array for scan in
	test_mux_sel_binary = ["{0:03b}".format(item) for item in test_mux_sel]
	test_mux_sel_binary = [list(item) for item in test_mux_sel_binary]
	test_mux_sel_bit = sum(test_mux_sel_binary, [])
	test_mux_sel_bit = [int(bit) for bit in test_mux_sel_bit]
	test_mux_sel_bit.reverse();
	print(test_mux_sel_bit)
	for i in range(sel_width * out_width):
		# push the last value into the scan chain
		# scan in MSB first
		dut.scan_in <= test_mux_sel_bit.pop(-1)
		dut.scan_en <= 1
		await RisingEdge(dut.clk)
		dut.scan_en <= 0

	await Timer(100000, units='ps')

	# test in gen
	test_in = []
	for i in range(in_width):
		test_in.append(random.randint(0, 1))
	# for i in range(0, (2**sel_width - in_width)):
	# 	test_in.append(0) 

	# test golden out gen
	test_golden_out = [0] * out_width
	for i in range(out_width):
		# print(int("".join(str(item) for item in test_mux_sel[3 * i : 3 * i + 3]), 2))
		# test_golden_out[i] = test_in[int("".join(str(item) for item in test_mux_sel[3 * i : 3 * i + 3]), 2)]
		test_golden_out[i] = test_in[test_mux_sel[i]]

	
	print(test_mux_sel)
	print(test_in)
	print(test_golden_out)
	# test_in.reverse()
	# print(int("".join(str(bit) for bit in test_in), 2))

	result = []
	# result2 = []
	test_in.reverse()
	dut.complete_in <= int("".join(str(bit) for bit in test_in), 2)
	await Timer(100, units='ps')
	result.append(dut.out.value)
	assert [str(item) for item in test_golden_out] == ["".join(str(item)) for item in dut.out.value]

