module SyncFifo (
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
  parameter int WIDTH = 64;

  input clk, reset, wen, ren;
  output full, empty;

  input [WIDTH-1:0] din;
  output reg [WIDTH-1:0] dout;


  reg [$clog2(DEPTH)-1:0] wtPtr, rdPtr;  // clog(8) = 3 [2:0]

  assign empty = wtPtr == rdPtr;
  assign full  = wtPtr + 1'b1 == rdPtr;
  reg [WIDTH-1 : 0] fifo[DEPTH];


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
      fifo[wtPtr] <= din;
    end
  end

  /*Read Operation - Can read indefinitely until we are "empty"*/
  always @(posedge clk) begin
    if (!empty && ren) begin
      rdPtr <= rdPtr + 1'b1;
      dout  <= fifo[rdPtr];
    end
  end

endmodule
