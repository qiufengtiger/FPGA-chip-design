CWD=$(shell pwd)

TOPLEVEL_LANG ?=verilog

ifeq ($(TOPLEVEL_LANG),verilog)
  VERILOG_SOURCES =$(CWD)/sram.v
else ifeq ($(TOPLEVEL_LANG),vhdl)
  VHDL_SOURCES =$(CWD)/sram.vhdl
else
  $(error "A valid value (verilog or vhdl) was not provided for TOPLEVEL_LANG=$(TOPLEVEL_LANG)")
endif

TOPLEVEL = sram
MODULE := $(TOPLEVEL)_test
COCOTB_HDL_TIMEUNIT=1us
COCOTB_HDL_TIMEPRECISION=1us

CUSTOM_SIM_DEPS=$(CWD)/Makefile

ifeq ($(SIM),questa)
    SIM_ARGS=-t 1ps
endif

ifneq ($(filter $(SIM),ius xcelium),)
    SIM_ARGS += -v93
endif

# SIM_ARGS += sram.ADDR_WIDTH=4
# SIM_ARGS += sram.DATA_WIDTH=1

include $(shell cocotb-config --makefiles)/Makefile.sim