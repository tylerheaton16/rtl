module AsyncFifo #(
    parameter W = 8,
    parameter DEPTH = 8
) (
    clk,
    reset,
    wen,
    ren,
    din,
    dout,
    full,
    empty
);

  localparam W2 = $clog2(W);  // W=8 then W2=3
  wire [ W2:0] rdPtr;
  wire [ W2:0] wtPtr;
  reg  [W-1:0] fifo  [DEPTH];

  wire isMsbOne = rdPtr[W2] ^ wtPtr[W2];
  assign empty = rdPtr == wtPtr;
  assign full = isMsbOne && (rdPtr[W2-1:0] == wtPtr[W2-1:0]);

  //g2b g2b_inst (
  //    .gray(gray),
  //    .bin (binary)
  //);

endmodule


//2FF synchronizer we can use to sync bits
module Synchronizer (
    input clk,
    input resetn,
    input in,
    output reg out

);
  reg q1;
  always @(posedge clk) begin
    if (~resetn) begin
      out <= 0;
      q1  <= 0;
    end else begin
      q1  <= in;
      out <= q1;
    end
  end
endmodule

module b2g #(
    parameter WIDTH = 8
) (
    input  wire [WIDTH-1:0] bin,
    output wire [WIDTH-1:0] gray
);

  assign gray = bin ^ (bin >> 1);
endmodule

module g2b #(
    parameter WIDTH = 8
) (
    input  wire [WIDTH-1:0] gray,
    output wire [WIDTH-1:0] bin

);
  assign bin[WIDTH-1] = gray[WIDTH-1];
  for (genvar i = 0; i < WIDTH - 1; i++) begin
    assign bin[i] = bin[i+1] ^ gray[i];
  end
endmodule
