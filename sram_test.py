import random
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import FallingEdge
from cocotb.triggers import RisingEdge

@cocotb.test()
async def test_sram(dut):
	data_width = dut.DATA_WIDTH.value.integer
	addr_width = dut.ADDR_WIDTH.value.integer
	dut._log.info("Found %d entry RAM by %d bits wide" % (addr_width, data_width))
	clock = Clock(dut.clk, 10, units="us")
	cocotb.fork(clock.start())

	for i in range(10):
		val = random.randint(0, 1)
		addr = random.randint(0, 15)
		dut._log.info("gen addr = %s" % (addr))
		await RisingEdge(dut.clk) 
		dut.we <= 1
		dut.waddr <= addr
		dut.wdata <= val
		dut._log.info("we = %s" % (dut.we))
		await RisingEdge(dut.clk)
		dut.we <= 0
		await FallingEdge(dut.clk)
		dut.raddr <= addr
		dut._log.info("addr = %s" % (dut.raddr))
		dut._log.info("val = %s" % (dut.rdata))
		assert dut.rdata == val, "output rdata was incorrect on the {}th cycle".format(i)
