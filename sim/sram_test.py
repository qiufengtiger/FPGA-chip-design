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
async def test_sram(dut):
	# data_width = dut.DATA_WIDTH.value.integer
	data_width = 1
	addr_width = dut.ADDR_WIDTH.value
	dut._log.info("Found %d entry RAM by %d bits wide" % (addr_width, data_width))
	clock = Clock(dut.clk, 10000, units="ps")
	cocotb.fork(clock.start())

	testSize = 2 ** addr_width
	# print(addr_width)
	# initialization
	testValues = []
	for i in range(testSize):
		testValues.append(random.randint(0, 1))
	testAddrs = list(range(0, 2**addr_width))

	# 0 => typical waddr / wdata, 1 => scan chain
	testMode = SCAN_CHAIN

	# print(testAddrs)
	# print(testValues)

	assert testMode is PORT or SCAN_CHAIN, "test mode not defined"
	if testMode is PORT:
		random.shuffle(testAddrs)
		for i in range(testSize):
			# await FallingEdge(dut.clk)
			dut.waddr <= testAddrs[i]
			dut.wdata <= testValues[i]
			dut.we <= 1
			await RisingEdge(dut.clk)
			dut.we <= 0

	elif testMode is SCAN_CHAIN:
		testValuesCopy = testValues.copy()
		# testValues.reverse()
		for i in range(testSize):
			# push the last value into the scan chain
			dut.scan_in <= testValuesCopy.pop(-1)
			dut.scan_en <= 1
			await RisingEdge(dut.clk)
			dut.scan_en <= 0

	await Timer(100000, units='ps')

	result = []
	result2 = []
	for i in range(testSize):
		dut.raddr <= testAddrs[i]
		await Timer(10, units='ps')
		result.append(dut.rdata.value)
		assert testValues[i] == dut.rdata.value

	for i in range(testSize):
		dut.raddr <= testAddrs[i]
		await Timer(10, units='ps')
		result2.append(dut.rdata.value)
		assert testValues[i] == dut.rdata.value