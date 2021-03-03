all: 
# force clean before compile
$(shell rm -rf ./__pycache__ ./sim_build)
$(shell rm -f results.xml)

CWD=$(shell pwd)

TOPLEVEL_LANG ?=verilog
SIM ?= icarus

# be sure to modify this when testing different module
FILENAME = sram
TOPLEVEL = sram

ifeq ($(TOPLEVEL_LANG),verilog)
  VERILOG_SOURCES =$(CWD)/$(FILENAME).v
else ifeq ($(TOPLEVEL_LANG),vhdl)
  VHDL_SOURCES =$(CWD)/$(FILENAME).vhdl
else
  $(error "A valid value (verilog or vhdl) was not provided for TOPLEVEL_LANG=$(TOPLEVEL_LANG)")
endif

# sram
export ADDR_WIDTH = 16
export DATA_WIDTH = 1

# clb
export WIDTH = 4

MODULE := $(TOPLEVEL)_test
COCOTB_HDL_TIMEUNIT=1us
COCOTB_HDL_TIMEPRECISION=1us

CUSTOM_SIM_DEPS=$(CWD)/Makefile

ifeq ($(TOPLEVEL),sram)
	COMPILE_ARGS += -Psram.ADDR_WIDTH=$(ADDR_WIDTH) -Psram.DATA_WIDTH=$(DATA_WIDTH)
else ifeq ($(TOPLEVEL),ble)
	COMPILE_ARGS += -Plut.WIDTH=$(WIDTH)
endif

include $(shell cocotb-config --makefiles)/Makefile.sim

clean::
	rm -rf ./__pycache__ ./sim_build
	rm -f results.xml