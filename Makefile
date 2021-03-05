all: 
# force clean before compile
$(shell rm -rf ./__pycache__ ./sim_build)
$(shell rm -f results.xml)

CWD=$(shell pwd)

TOPLEVEL_LANG ?=verilog
SIM ?= icarus

# be sure to modify this when testing different module
FILENAME = clb
TOPLEVEL = clb_complete_conn

ifeq ($(TOPLEVEL_LANG),verilog)
  VERILOG_SOURCES =$(CWD)/$(FILENAME).v
else ifeq ($(TOPLEVEL_LANG),vhdl)
  VHDL_SOURCES =$(CWD)/$(FILENAME).vhdl
else
  $(error "A valid value (verilog or vhdl) was not provided for TOPLEVEL_LANG=$(TOPLEVEL_LANG)")
endif

# sram
export ADDR_WIDTH = 4
export DATA_WIDTH = 1

# clb
export WIDTH = 4

# complete_conn
export IN_WIDTH = 5
export OUT_WIDTH = 4
export MUX_SEL_WIDTH = 3

MODULE := $(TOPLEVEL)_test
COCOTB_HDL_TIMEUNIT=1us
COCOTB_HDL_TIMEPRECISION=1us

CUSTOM_SIM_DEPS=$(CWD)/Makefile

ifeq ($(TOPLEVEL),sram)
	COMPILE_ARGS += -Psram.ADDR_WIDTH=$(ADDR_WIDTH) -Psram.DATA_WIDTH=$(DATA_WIDTH)
else ifeq ($(TOPLEVEL),ble)
	COMPILE_ARGS += -Plut.WIDTH=$(WIDTH)
else ifeq ($(TOPLEVEL),clb_complete_conn)
	COMPILE_ARGS += -Pclb_complete_conn.IN_WIDTH=$(IN_WIDTH) -Pclb_complete_conn.OUT_WIDTH=$(OUT_WIDTH) -Pclb_complete_conn.MUX_SEL_WIDTH=$(MUX_SEL_WIDTH)
endif

include $(shell cocotb-config --makefiles)/Makefile.sim

clean::
	rm -rf ./__pycache__ ./sim_build
	rm -f results.xml