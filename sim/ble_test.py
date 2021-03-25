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
async def test_ble(dut):
	width = dut.WIDTH.value
	dut._log.info("Found %d bits LUT" % (width))
	clock = Clock(dut.scan_clk, 10000, units="ps")
	cocotb.fork(clock.start())

	test_size = 2 ** width

	# initialization
	test_values = []
	for i in range(test_size):
		test_values.append(random.randint(0, 1))
	test_addrs = list(range(0, 2**width))
	
	# 0 => typical waddr / wdata, 1 => scan chain
	test_mode = SCAN_CHAIN

	assert test_mode is PORT or SCAN_CHAIN, "test mode not defined"
	if test_mode is PORT:
		random.shuffle(test_addrs)
		for i in range(test_size):
			# await FallingEdge(dut.clk)
			dut.lut_in <= test_addrs[i]
			dut.set_in <= test_values[i]
			dut.set <= 1
			await RisingEdge(dut.scan_clk)
			dut.set <= 0

	elif test_mode is SCAN_CHAIN:
		test_valuesCopy = test_values.copy()
		# test_values.reverse()
		for i in range(test_size):
			# push the last value into the scan chain
			dut.scan_in <= test_valuesCopy.pop(-1)
			dut.scan_en <= 1
			await RisingEdge(dut.scan_clk)
			dut.scan_en <= 0

	await Timer(100000, units='ps')

	result = []
	result2 = []
	dut.is_comb <= 1
	for i in range(test_size):
		dut.lut_in <= test_addrs[i]
		await Timer(10, units='ps')
		result.append(dut.out.value)
		dut._log.info("expected: %s, actual = %s" % (test_values[i], dut.out.value))
		assert test_values[i] == dut.out.value

	for i in range(test_size):
		dut.lut_in <= test_addrs[i]
		await Timer(10, units='ps')
		result2.append(dut.out.value)
		assert test_values[i] == dut.out.value