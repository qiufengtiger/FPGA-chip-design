import random
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import FallingEdge
from cocotb.triggers import RisingEdge
from cocotb.triggers import Timer
from cocotb.binary import BinaryValue
from helper import int_list_to_bitstream
from helper import bin_list_to_int_little_endian
from helper import int_to_bin_list_little_endian
import os

@cocotb.test()
async def test_fpga_top_2x2(dut):
	clock = Clock(dut.scan_clk, 10000, units="ps")
	cocotb.fork(clock.start())

	# 2 * 2 fpga
	# built for primary fpga functional test because bitstream generator is pending complete
	# bitstream used in this testbench is hand-translated from VTR result

	# io info:
	# io_0: C, io_1: B, io_2: A, io_3: D
	# C = A | B, D = A & B
	tile_2_A_port = 0
	tile_3_A_port = 0
	tile_2_B_port = 2
	tile_3_B_port = 2

	sb_0_config_left = [1, 0, 0, 0]
	sb_0_config_right = [0, 0, 0, 0]
	sb_0_config_top = [0, 0, 0, 2]
	sb_0_config_bottom = [0, 0, 0, 0]
	sb_0_config = sb_0_config_left + sb_0_config_right + sb_0_config_top + sb_0_config_bottom

	sb_1_config_left = [2, 0, 1, 0]
	sb_1_config_right = [0, 1, 2, 0]
	sb_1_config_top = [2, 0, 0, 2]
	sb_1_config_bottom = [0, 0, 0, 0]
	sb_1_config = sb_1_config_left + sb_1_config_right + sb_1_config_top + sb_1_config_bottom

	sb_2_config_left = [0, 0, 0, 0]
	sb_2_config_right = [0, 0, 1, 3]
	sb_2_config_top = [1, 0, 0, 0]
	sb_2_config_bottom = [0, 0, 0, 0]
	sb_2_config = sb_2_config_left + sb_2_config_right + sb_2_config_top + sb_2_config_bottom

	sb_3_config_left = [0, 0, 0, 0]
	sb_3_config_right = [0, 0, 0, 3]
	sb_3_config_top = [0, 0, 0, 0]
	sb_3_config_bottom = [2, 0, 0, 0]
	sb_3_config = sb_3_config_left + sb_3_config_right + sb_3_config_top + sb_3_config_bottom

	sb_4_config_left = [0, 0, 0, 0]
	sb_4_config_right = [0, 0, 0, 0]
	sb_4_config_top = [0, 0, 0, 0]
	sb_4_config_bottom = [0, 0, 0, 0]
	sb_4_config = sb_4_config_left + sb_4_config_right + sb_4_config_top + sb_4_config_bottom

	cb_0_config = [0, 1]
	cb_1_config = [0, 0]
	cb_2_config = [0, 0]
	cb_3_config = [0, 0]

	# cb_0 -> top, cb_1 -> right
	tile_0_cb_0_config = [0, 0]
	tile_0_cb_1_config = [0, 0]
	tile_0_sb_config_left = [0, 0, 0, 0]
	tile_0_sb_config_right = [0, 0, 0, 0]
	tile_0_sb_config_top = [0, 0, 0, 0]
	tile_0_sb_config_bottom = [0, 1, 0, 0]
	tile_0_conn_config = tile_0_sb_config_left + tile_0_sb_config_right + tile_0_sb_config_top + tile_0_sb_config_bottom
	tile_0_conn_config += tile_0_cb_0_config + tile_0_cb_1_config

	tile_1_cb_0_config = [0, 0]
	tile_1_cb_1_config = [0, 0]
	tile_1_sb_config_left = [0, 0, 0, 0]
	tile_1_sb_config_right = [0, 0, 0, 0]
	tile_1_sb_config_top = [0, 0, 0, 0]
	tile_1_sb_config_bottom = [0, 0, 0, 0]
	tile_1_conn_config = tile_1_sb_config_left + tile_1_sb_config_right + tile_1_sb_config_top + tile_1_sb_config_bottom
	tile_1_conn_config += tile_1_cb_0_config + tile_1_cb_1_config

	tile_2_cb_0_config = [0, 2]
	tile_2_cb_1_config = [0, 0]
	tile_2_sb_config_left = [0, 0, 0, 0]
	tile_2_sb_config_right = [0, 0, 0, 0]
	tile_2_sb_config_top = [2, 0, 0, 0]
	tile_2_sb_config_bottom = [0, 2, 0, 0]
	tile_2_conn_config = tile_2_sb_config_left + tile_2_sb_config_right + tile_2_sb_config_top + tile_2_sb_config_bottom
	tile_2_conn_config += tile_2_cb_0_config + tile_2_cb_1_config

	tile_3_cb_0_config = [0, 2]
	tile_3_cb_1_config = [0, 0]
	tile_3_sb_config_left = [0, 0, 0, 0]
	tile_3_sb_config_right = [0, 0, 0, 3]
	tile_3_sb_config_top = [0, 0, 0, 0]
	tile_3_sb_config_bottom = [0, 0, 0, 2]
	tile_3_conn_config = tile_3_sb_config_left + tile_3_sb_config_right + tile_3_sb_config_top + tile_3_sb_config_bottom
	tile_3_conn_config += tile_3_cb_0_config + tile_3_cb_1_config

	conn_config = sb_0_config + cb_0_config + sb_1_config + cb_1_config + sb_2_config + cb_2_config
	conn_config += sb_3_config + cb_3_config + sb_4_config
	conn_config += tile_0_conn_config + tile_1_conn_config + tile_2_conn_config + tile_3_conn_config

	# index -> tile id
	is_comb = [[1], [1], [1], [1]]
	# [3:0] -> clb_in[3:0], 4 -> ble_out, 5 -> 1'b0
	tile_0_complete_config = [5, 5, 5, 5]
	tile_1_complete_config = [0, 0, 0, 0]
	tile_2_complete_config = [0, 5, 2, 5]
	tile_3_complete_config = [0, 5, 2, 5]

	tile_0_complete_binary = int_list_to_bitstream(tile_0_complete_config, 3)
	tile_1_complete_binary = int_list_to_bitstream(tile_1_complete_config, 3)
	tile_2_complete_binary = int_list_to_bitstream(tile_2_complete_config, 3)
	tile_3_complete_binary = int_list_to_bitstream(tile_3_complete_config, 3)

	
	conn_bitstream = int_list_to_bitstream(conn_config, 2)
	conn_scan_size = len(conn_bitstream)

	# print(conn_bitstream)

	tile_0_lut_config = [0 for i in range(16)]
	tile_1_lut_config = [0 for i in range(16)]
	tile_2_lut_config = [1 for i in range(16)]
	tile_3_lut_config = [0 for i in range(16)]

	# set lut value
	for index, value in enumerate(tile_2_lut_config):
		index_binary = int_to_bin_list_little_endian(index, 4)
		if index_binary[tile_2_A_port] == 0 and index_binary[tile_2_B_port] == 0:
			tile_2_lut_config[index] = 0

	for index, value in enumerate(tile_3_lut_config):
		index_binary = int_to_bin_list_little_endian(index, 4)
		if index_binary[tile_3_A_port] == 1 and index_binary[tile_3_B_port] == 1:
			tile_3_lut_config[index] = 1

	lut_bitstream = is_comb[0] + tile_0_complete_binary + tile_0_lut_config
	lut_bitstream += is_comb[1] + tile_1_complete_binary + tile_1_lut_config 
	lut_bitstream += is_comb[2] + tile_2_complete_binary + tile_2_lut_config 
	lut_bitstream += is_comb[3] + tile_3_complete_binary + tile_3_lut_config  
	lut_scan_size = len(lut_bitstream)

	print("lut bitstream:")
	print(lut_bitstream)
	print("conn bitstream:")
	print(conn_bitstream)

	dut.clb_scan_en <= 1
	for i in range(lut_scan_size):
		dut.clb_scan_in <= lut_bitstream.pop(-1)
		await RisingEdge(dut.scan_clk)
	dut.clb_scan_en <= 0

	dut.conn_scan_en <= 1
	for i in range(conn_scan_size):
		dut.conn_scan_in <= conn_bitstream.pop(-1)
		await RisingEdge(dut.scan_clk)
	dut.conn_scan_en <= 0

	await Timer(100, units='ps')

	test_in_A = random.randint(0, 1)
	test_in_B = random.randint(0, 1)

	# dut.fpga_in[0] <= 0
	# B
	dut.fpga_in[1] <= test_in_B
	# A
	dut.fpga_in[2] <= test_in_A
	# dut.fpga_in[3] <= 0

	await Timer(100, units='ps')

	result_C = dut.fpga_out[0]
	result_D = dut.fpga_out[3]

	assert result_C == test_in_A | test_in_B, "port 0 (C) mismatch"
	assert result_D == test_in_A & test_in_B, "port 3 (D) mismatch"


