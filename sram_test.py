import random
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import FallingEdge
from cocotb.triggers import RisingEdge
from cocotb.triggers import Timer

@cocotb.test()
async def test_sram(dut):
	data_width = dut.DATA_WIDTH.value.integer
	addr_width = dut.ADDR_WIDTH.value.integer
	dut._log.info("Found %d entry RAM by %d bits wide" % (addr_width, data_width))
	clock = Clock(dut.clk, 10, units="us")
	cocotb.fork(clock.start())

	# initialization
	testValues = [1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0]
	testAddrs = []
	for i in range(10):
		# testValues.append(random.randint(0, 1))
		testAddrs.append(random.randint(0, 15))

	for i in range(10):
		dut.we <= 1
		dut.waddr <= testAddrs[i]
		dut.wdata <= testValues[i]
		dut._log.info("waddr = %s, wdata = %s, i = %s, input = %s" % (dut.waddr.value, dut.wdata.value, i, testValues[i]))
		await FallingEdge(dut.clk)
		dut.we <= 0

	result = []
	for i in range(0, 10):
		# dut.raddr <= testAddrs[i]
		# await Timer(100, units='ps')
		# result = dut.rdata.value
		# dut._log.info("raddr = %s, rdata = %s, i = %s, expected = %s" % (dut.raddr.value, result, i, testValues[i]))
		# assert result == testValues[i], "output was incorrect on the {}th cycle".format(i)
		dut.raddr <= testAddrs[i]
		await Timer(1000, units='us')
		result.append(dut.rdata.value)
	print(testValues)
	print(result)