######################################################################
#
# DESCRIPTION: Verilator Example: Small Makefile
#
# This calls the object directory makefile.  That allows the objects to
# be placed in the "current directory" which simplifies the Makefile.
#
# This file ONLY is placed under the Creative Commons Public Domain, for
# any use, without warranty, 2020 by Wilson Snyder.
# SPDX-License-Identifier: CC0-1.0
#
######################################################################
# Check for sanity to avoid later confusion

ifneq ($(words $(CURDIR)),1)
 $(error Unsupported: GNU Make cannot build in directories containing spaces, build elsewhere: '$(CURDIR)')
endif

######################################################################

# This is intended to be a minimal example.  Before copying this to start a
# real project, it is better to start with a more complete example,
# e.g. examples/make_tracing_c.

# If $VERILATOR_ROOT isn't in the environment, we assume it is part of a
# package install, and verilator is in your path. Otherwise find the
# binary relative to $VERILATOR_ROOT (such as when inside the git sources).
ifeq ($(VERILATOR_ROOT),)
VERILATOR = verilator
else
export VERILATOR_ROOT
VERILATOR = $(VERILATOR_ROOT)/bin/verilator
endif

list:
	@grep '^[^#[:space:]].*:' Makefile

######################################################################

fifo:
	@echo "-- Verilator hello-world simple binary example"
	@echo "-- VERILATE & BUILD --------"
	$(VERILATOR) --binary -j 0 verilog/fifos/SyncFifo.sv verilog/fifos/SyncFifo_tb.sv
	@echo "-- RUN ---------------------"
	obj_dir/VSyncFifo
	@echo "-- DONE --------------------"

######################################################################

fifoOpt:
	@echo "-- Verilator hello-world simple binary example"
	@echo "-- VERILATE & BUILD --------"
	$(VERILATOR) --binary -j 0 verilog/fifos/SyncFifoOptimized.sv verilog/fifos/SyncFifoOptimized_tb.sv
	@echo "-- RUN ---------------------"
	obj_dir/VSyncFifo
	@echo "-- DONE --------------------"

######################################################################

maintainer-copy::
clean mostlyclean distclean maintainer-clean::
	-rm -rf obj_dir *.log *.dmp *.vpd core
