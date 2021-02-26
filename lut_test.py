import random
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import FallingEdge
from cocotb.triggers import RisingEdge
from cocotb.triggers import Timer
import os

@cocotb.test()
async def test_lut(dut):
	width = dut.WIDTH.value.integer
	dut._log.info("Found %d bits LUT" % (width))
	clock = Clock(dut.clk, 10000, units="ps")
	cocotb.fork(clock.start())

	testSize = 10

	# initialization
	testValues = []
	for i in range(testSize):
		testValues.append(random.randint(0, 1))
	testAddrs = list(range(0, 2**width-1))
	random.shuffle(testAddrs)

	for i in range(testSize):
		# await FallingEdge(dut.clk)
		dut.lut_in <= testAddrs[i]
		dut.set_in <= testValues[i]
		dut.set <= 1
		await RisingEdge(dut.clk)
		dut.set <= 0

	await Timer(100000, units='ps')

	result = []
	result2 = []
	dut.set <= 0
	dut.is_comb <= 1
	for i in range(testSize):
		dut.lut_in <= testAddrs[i]
		await Timer(10, units='ps')
		result.append(dut.out.value)
		dut._log.info("expected: %s, actual = %s" % (testValues[i], dut.out.value))
		assert testValues[i] == dut.out.value

	for i in range(testSize):
		dut.lut_in <= testAddrs[i]
		await Timer(10, units='ps')
		result2.append(dut.out.value)
		assert testValues[i] == dut.out.value