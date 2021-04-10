all: 
# force clean before compile
$(shell rm -rf ./__pycache__ ./sim_build)
$(shell rm -f results.xml)

CWD=$(shell pwd)
SRC_DIR = $(CWD)/src
MAPPED_SRC_DIR = $(CWD)/syn_mapped
# setup bitstream
TEST_NAME = blink
BITSTREAM_DIR = $(CWD)/bitstream
export BITSTREAM_ROUTE_PATH = $(BITSTREAM_DIR)/$(TEST_NAME)_route.bitstream
export BITSTREAM_CLB_PATH = $(BITSTREAM_DIR)/$(TEST_NAME)_clb.bitstream

TOPLEVEL_LANG ?=verilog
SIM ?= icarus

# be sure to modify this when testing different module
FILENAME = fpga_core
TOPLEVEL = fpga_core
IS_MAPPED = 0

ifeq ($(IS_MAPPED), 0)
	COMPILE_ARGS =-I$(SRC_DIR)
	VERILOG_SOURCES = $(SRC_DIR)/$(FILENAME).v
else ifeq ($(IS_MAPPED), 1)
	FILENAME_MAPPED = $(FILENAME)_mapped
	COMPILE_ARGS =-I$(MAPPED_SRC_DIR)
	VERILOG_SOURCES = $(MAPPED_SRC_DIR)/$(FILENAME_MAPPED).v
endif


export PYTHONPATH = $(CWD)/sim

# sram
export ADDR_WIDTH = 4
export DATA_WIDTH = 1

# ble
export WIDTH = 4

# complete_conn
export IN_WIDTH = 6
export OUT_WIDTH = 4
export MUX_SEL_WIDTH = 3

# clb
export CLB_IN_WIDTH = 4
export CLB_BLE_NUM = 1
export CONN_SEL_WIDTH = 3

# switch_block & connection_block
export CHANNEL_ONEWAY_WIDTH = 4

# tile parameters are included above
BITSTREAM_TEST = 1
ifeq ($(BITSTREAM_TEST), 0)
	MODULE := $(TOPLEVEL)_test
else ifeq ($(BITSTREAM_TEST), 1)
	MODULE := $(TOPLEVEL)_$(TEST_NAME)_test
endif
COCOTB_HDL_TIMEUNIT=1us
COCOTB_HDL_TIMEPRECISION=1us

CUSTOM_SIM_DEPS=$(CWD)/Makefile



ifeq ($(TOPLEVEL),sram)
	COMPILE_ARGS += -Psram.ADDR_WIDTH=$(ADDR_WIDTH) -Psram.DATA_WIDTH=$(DATA_WIDTH)
else ifeq ($(TOPLEVEL),ble)
	COMPILE_ARGS += -Plut.WIDTH=$(WIDTH)
else ifeq ($(TOPLEVEL),clb_complete_conn)
	COMPILE_ARGS += -Pclb_complete_conn.IN_WIDTH=$(IN_WIDTH) -Pclb_complete_conn.OUT_WIDTH=$(OUT_WIDTH) -Pclb_complete_conn.MUX_SEL_WIDTH=$(MUX_SEL_WIDTH)
else ifeq ($(TOPLEVEL),clb)
	COMPILE_ARGS += -Pclb.CLB_IN_WIDTH=$(CLB_IN_WIDTH) -Pclb.CLB_BLE_NUM=$(CLB_BLE_NUM) -Pclb.CONN_SEL_WIDTH=$(CONN_SEL_WIDTH)
else ifeq ($(TOPLEVEL),switch_block)
	COMPILE_ARGS += -Pswitch_block.CHANNEL_ONEWAY_WIDTH=$(CHANNEL_ONEWAY_WIDTH)
else ifeq ($(TOPLEVEL),switch_block_edge)
	COMPILE_ARGS += -Pswitch_block_edge.CHANNEL_ONEWAY_WIDTH=$(CHANNEL_ONEWAY_WIDTH)
else ifeq ($(TOPLEVEL),connection_block)
	COMPILE_ARGS += -Pconnection_block.CHANNEL_ONEWAY_WIDTH=$(CHANNEL_ONEWAY_WIDTH)
else ifeq ($(TOPLEVEL),tile)
	COMPILE_ARGS += -Ptile.CHANNEL_ONEWAY_WIDTH=$(CHANNEL_ONEWAY_WIDTH) -Ptile.CLB_BLE_NUM=$(CLB_BLE_NUM) -Ptile.CONN_SEL_WIDTH=$(CONN_SEL_WIDTH)
endif

# COMPILE_ARGS += -gspecify

include $(shell cocotb-config --makefiles)/Makefile.sim
# $(shell cd ..)

clean::
	rm -rf ./sim/__pycache__ ./sim_build
	rm -f results.xml