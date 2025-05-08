module SimpleRouter #(
    parameter DATA_WIDTH = 32
) (
    input [DATA_WIDTH-1] din,
    input din_en,
    input [1:0] addr,
    output [DATA_WIDTH-1] dout0,
    output [DATA_WIDTH-1] dout1,
    output [DATA_WIDTH-1] dout2,
    output [DATA_WIDTH-1] dout3
);
  assign dout0 = (din_en & addr == 0) ? din : 1'b0;
  assign dout1 = (din_en & addr == 1) ? din : 1'b0;
  assign dout2 = (din_en & addr == 2) ? din : 1'b0;
  assign dout2 = (din_en & addr == 3) ? din : 1'b0;

  /*
din -> dout0/1/2/3 specified by address input addr
*/
endmodule
