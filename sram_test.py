import random
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import FallingEdge
from cocotb.triggers import RisingEdge
from cocotb.triggers import Timer
import os

@cocotb.test()
async def test_sram(dut):
	data_width = dut.DATA_WIDTH.value.integer
	addr_width = dut.ADDR_WIDTH.value.integer
	dut._log.info("Found %d entry RAM by %d bits wide" % (addr_width, data_width))
	clock = Clock(dut.clk, 10000, units="ps")
	cocotb.fork(clock.start())

	testSize = 100

	# initialization
	testValues = []
	for i in range(testSize):
		testValues.append(random.randint(0, 1))
	testAddrs = list(range(0, 2**addr_width-1))
	random.shuffle(testAddrs)

	for i in range(testSize):
		# await FallingEdge(dut.clk)
		dut.waddr <= testAddrs[i]
		dut.wdata <= testValues[i]
		dut.we <= 1
		await RisingEdge(dut.clk)
		dut.we <= 0

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