import random
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import FallingEdge
from cocotb.triggers import RisingEdge
from cocotb.triggers import Timer
import os

PORT = 0
SCAN_CHAIN = 1

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
	testMuxSel = []
	for i in range(out_width):
		testMuxSel.append(random.randint(0, in_width - 1))
	# convert int to binary array for scan in
	testMuxSelBinary = ["{0:03b}".format(item) for item in testMuxSel]
	testMuxSelBinary = [list(item) for item in testMuxSelBinary]
	testMuxSelBit = sum(testMuxSelBinary, [])
	testMuxSelBit = [int(bit) for bit in testMuxSelBit]
	# MSB -> LSB
	testMuxSelBit.reverse();
	print(testMuxSelBit)
	for i in range(sel_width * out_width):
		# push the last value into the scan chain
		# scan in MSB first
		dut.scan_in <= testMuxSelBit.pop(-1)
		dut.scan_en <= 1
		await RisingEdge(dut.clk)
		dut.scan_en <= 0

	await Timer(100000, units='ps')

	print(dut.config_test.value)
	print(dut.c1.value)

	# test in gen
	testIn = []
	for i in range(in_width):
		testIn.append(random.randint(0, 1))
	# for i in range(0, (2**sel_width - in_width)):
	# 	testIn.append(0) 

	# test golden out gen
	testGoldenOut = [0] * out_width
	for i in range(out_width):
		# print(int("".join(str(item) for item in testMuxSel[3 * i : 3 * i + 3]), 2))
		# testGoldenOut[i] = testIn[int("".join(str(item) for item in testMuxSel[3 * i : 3 * i + 3]), 2)]
		testGoldenOut[i] = testIn[testMuxSel[i]]

	
	print(testMuxSel)
	print(testIn)
	print(testGoldenOut)
	# testIn.reverse()
	# print(int("".join(str(bit) for bit in testIn), 2))

	result = []
	# result2 = []
	testIn.reverse()
	dut.complete_in <= int("".join(str(bit) for bit in testIn), 2)
	await Timer(100, units='ps')
	result.append(dut.out.value)
	# assert testValues[i] == dut.rdata.value
	print(result)

