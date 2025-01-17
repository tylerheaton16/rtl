module Synchronizer (
    clk,
    reset,
    din,
    dout
);

  parameter int WIDTH = 64;
  input logic clk, reset;
  input logic [WIDTH-1:0] din;
  output logic [WIDTH-1:0] dout;

endmodule
