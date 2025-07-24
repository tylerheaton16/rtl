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

async def reset_design(reset, duration_ns):
    """toggle reset"""
    reset.value = 1
    await Timer(duration_ns, unit="ns")
    reset.value = 0
    cocotb.log.debug("Reset Complete")

async def write_and_read(din, wen, ren, dout, width, period, clk, depth):
    """Write to the fifo, then read from the fifo"""
    queue = deque(maxlen=depth)   # Create an empty deque


    wen.value = random.randint(0,1)
    din.value = random.randint(0,(2**width)-1)
    cocotb.log.debug("wen.value is equal to: %d" % wen.value)
    cocotb.log.debug("din.value is equal to: %d" % din.value)

    #Makes sure a rising edge occurs to check the wen.value
    await RisingEdge(clk)
    if wen.value == 1:
        queue.append(din.value)


    await RisingEdge(clk)
    ren.value = random.randint(0,1)
    cocotb.log.debug("ren.value is equal to: %d" % ren.value)
    dout_check = queue.popleft() if ren.value == 1 and queue else 0# Dequeue (efficient O(1))

    await Timer(period, "ns")

    if not queue:
        cocotb.log.info("QUEUE is empty - ending test")
        return

    assert dout.value == dout_check and queue


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

    for _ in range(10):
        await write_and_read(dut.din, dut.wen, dut.ren, dut.dout, int(dut.WIDTH), period, dut.clk, int(dut.DEPTH))
