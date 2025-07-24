module SyncFifoOptimized (
    clk,
    reset,
    wen,
    ren,
    din,
    dout,
    full,
    empty
);

  parameter int DEPTH = 8;
  parameter int WIDTH = 16;
  localparam MSB_PTR = $clog2(DEPTH);

  input clk, reset, wen, ren;
  input [WIDTH-1:0] din;
  output full, empty;
  output logic [WIDTH-1:0] dout;

  logic [MSB_PTR:0] wtPtr, rdPtr;  // clog(8) = 3 [3:0]
  logic [WIDTH-1 : 0] fifo[DEPTH];
  logic isMsbOne;

  /*
    NOTE: don't do `-1` because we want to increase the size of wt/rdPtr
    in order to calculate empty/full without losing a memory location
  */

  //Empty = when MSB of wtPtr and rdPtr are equal AND wtPtr == rdPtr for lower 3 bits
  assign empty = wtPtr == rdPtr;
  //Full = when MSB of wtPtr and rdPtr differ AND wtPtr == rdPtr for lower 3 bits
  assign full = isMsbOne && (wtPtr[MSB_PTR-1:0] == rdPtr[MSB_PTR-1:0]);
  //If isMsbOne == 1, then wtPtr and rdPtr = 1
  assign isMsbOne = wtPtr[MSB_PTR] ^ rdPtr[MSB_PTR];




  /*Reset condition - active low reset*/
  always @(posedge clk) begin
    if (!reset) begin
      dout  <= 0;
      wtPtr <= 0;
      rdPtr <= 0;
    end
  end

  /*Write Operation - Can write indefinitely until we are "full"*/
  always @(posedge clk) begin
    if (!full && wen) begin
      wtPtr <= wtPtr + 1'b1;
      fifo[wtPtr[MSB_PTR-1:0]] <= din;
    end
  end

  /*Read Operation - Can read indefinitely until we are "empty"*/
  always @(posedge clk) begin
    if (!empty && ren) begin
      rdPtr <= rdPtr + 1'b1;
      dout  <= fifo[rdPtr[MSB_PTR-1:0]];
    end
  end

endmodule
