# Makefile

# defaults
SIM ?= verilator
TOPLEVEL_LANG ?= verilog

EXTRA_ARGS += --trace --trace-structs
VERILOG_SOURCES += $(PWD)/../verilog/fifos/SyncFifoOptimized.sv
# use VHDL_SOURCES for VHDL files

# TOPLEVEL is the name of the toplevel module in your Verilog or VHDL file
COCOTB_TOPLEVEL = SyncFifoOptimized

# MODULE is the basename of the Python test file
COCOTB_TEST_MODULES = test_SyncFifoOptimized

# include cocotb's make rules to take care of the simulator setup
include $(shell cocotb-config --makefiles)/Makefile.sim
