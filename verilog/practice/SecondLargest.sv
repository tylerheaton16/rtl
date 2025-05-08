module SecondLargest #(
    parameter DATA_WIDTH = 32
) (
    input clk,
    input resetn,
    input [DATA_WIDTH-1] din,
    output logic [DATA_WIDTH-1] dout

);
  reg [DATA_WIDTH-1:0] largest;
  reg [DATA_WIDTH-1:0] second_largest;

  always @(posedge clk) begin
    if (~resetn) begin
       largest <= 0;
       second_largest <= 0;
      //Note: else if is prioritized in order, so the first will always be checked
    end else if (din > largest && din > second_largest) begin
      largest <= din;
      second_largest <= largest;
    end else if(din > largest) begin
      second_largest <= din;
    end
  end

  assign dout = second_largest;


  /*
  1) if only 1 value seen, dout = 0
  */

endmodule
