#This file tests the SyncFifoOptimized using cocotb
import os
import random
import sys
from pathlib import Path

import cocotb
import logging
from typing import cast
from cocotb.triggers import Timer
from cocotb_tools.runner import get_runner
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge
from collections import deque

cocotb.log.setLevel(logging.DEBUG)
queue = deque(maxlen=16)   # Create an empty deque

async def reset_design(reset, duration_ns):
    """toggle reset"""
    reset.value = 0
    await Timer(duration_ns, unit="ns")
    reset.value = 1
    cocotb.log.debug("Reset Complete")

async def write_and_read(din, wen, ren, dout, width, period, clk, depth, full):
    """Write to the fifo, then read from the fifo"""

    await RisingEdge(clk)

    wen_value = random.randint(0,1)
    din_value = random.randint(0,(2**width)-1)

    #assigning signals to values
    wen.value = wen_value
    din.value = din_value

    #logging signals with values
    cocotb.log.debug("wen.value = %d" % wen_value)
    cocotb.log.debug("din.value = %d" % din_value)

    if wen_value == 1 and not int(full):
        queue.append(din_value)

    await RisingEdge(clk)

    # must assign wen.value to 0 1 cycle later
    wen.value = 0

    ren_value = random.randint(0,1)
    ren.value = ren_value

    cocotb.log.debug("ren.value = %d" % ren_value)

    #await 1 clock cycle and we will see valid data
    await RisingEdge(clk)
    ren.value = 0

    if ren.value == 1 and queue:
        dout_check = queue.popleft()
        await RisingEdge(clk)
        cocotb.log.debug("dout.value = %d" % dout.value)
        cocotb.log.debug("dout_check = %d" % dout_check)
        assert int(dout.value) == dout_check, (
         f"dout.value != dout_check: {int(dout.value)} != {dout_check}"
            )
    elif queue:
        cocotb.log.info("Queue contains data - did not issue a read")
    else:
        cocotb.log.info("Queue is empty - nothing to read")



@cocotb.test()
async def syncfifo_basic_test(dut):
    """Test for filling fifo by 1, then dequeing"""
    period = 10
    reset = dut.reset
    cocotb.start_soon(Clock(dut.clk, period, unit="ns").start())

    #wait for reset to complete
    reset_thread = cocotb.start_soon(reset_design(reset, duration_ns=500))
    await reset_thread
    cocotb.log.debug("After Reset")

    for _ in range(1000):
        await write_and_read(dut.din, dut.wen, dut.ren, dut.dout, int(dut.WIDTH.value), period, dut.clk, int(dut.DEPTH.value), dut.full)
