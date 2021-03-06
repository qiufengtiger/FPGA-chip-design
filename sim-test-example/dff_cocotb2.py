import random
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import FallingEdge

@cocotb.test()
async def test_dff_simple(dut):
    """ Test that d propagates to q """

    clock = Clock(dut.c, 10, units="us")  # Create a 10us period clock on port clk
    cocotb.fork(clock.start())  # Start the clock

    for i in range(10):
        val = random.randint(0, 1)
        dut.d <= val  # Assign the random value val to the input port d
        dut._log.info("d = %s" % (dut.d))
        await FallingEdge(dut.c)
        assert dut.q == val, "output q was incorrect on the {}th cycle".format(i)