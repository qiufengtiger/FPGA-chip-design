import random
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import FallingEdge
from cocotb.triggers import RisingEdge
from cocotb.triggers import Timer
from cocotb.binary import BinaryValue
from helper import int_list_to_bitstream
import os

@cocotb.test()
async def test_cb(dut):
	clock = Clock(dut.clk, 10000, units="ps")
	cocotb.fork(clock.start())

	width = dut.CHANNEL_ONEWAY_WIDTH.value.integer
	dut._log.info("Found CB with channel oneway width %d" % (width))

	# random config generation
	out_config = [random.randint(0, 3) for i in range(2)]
	out_config_binary = int_list_to_bitstream(out_config, 2)

	# random input generation
	tracks_0 = random.randint(0, 2 ** width - 1)
	tracks_1 = random.randint(0, 2 ** width - 1)

	bitstream = out_config_binary
	total_scan_size = len(bitstream)

	print(bitstream)

	# scan in config
	dut.scan_en <= 1
	for i in range(total_scan_size):
		# push the last value into the scan chain
		# scan in MSB first
		dut.scan_in <= bitstream.pop(-1)
		await RisingEdge(dut.clk)
	dut.scan_en <= 0
	
	dut.tracks_0 <= tracks_0
	dut.tracks_1 <= tracks_1

	await Timer(100, units='ps')

	out_0 = dut.out_0.value
	out_1 = dut.out_1.value	

	# convert int to cocotb BinaryValue for easy bit select
	tracks_0 = BinaryValue(tracks_0, n_bits=4, bigEndian=False)
	tracks_1 = BinaryValue(tracks_1, n_bits=4, bigEndian=False)

	golden_out_0 = {3: tracks_0[0], 2: tracks_1[0], 1: tracks_0[2], 0: tracks_1[2]}
	golden_out_1 = {3: tracks_0[1], 2: tracks_1[1], 1: tracks_0[3], 0: tracks_1[3]}

	assert out_0 == golden_out_0[out_config[0]], "out_0 expecting %d, getting %d" % (golden_out_0[out_config[0]], out_0)
	assert out_1 == golden_out_1[out_config[1]], "out_1 expecting %d, getting %d" % (golden_out_1[out_config[1]], out_1)







