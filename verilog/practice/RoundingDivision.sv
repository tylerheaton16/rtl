module RoundingDivision #(parameter
  DIV_LOG2=3,
  OUT_WIDTH=32,
  IN_WIDTH=OUT_WIDTH+DIV_LOG2
) (
  input [IN_WIDTH-1:0] din,
  output logic [OUT_WIDTH-1:0] dout
);
  /*
  1) Divide input by 2^DIV_LOG2 and round to nearest integer
  2) 2.5 round up to 3, 4.5 round up to 5
  3) if OUT_WIDTH = 2, max result = 3 so 3.5 saturates to 3
  */
  //wire maybeSaturated;

  //assign  maybeSaturated = $clog2((din / (s**DIV_LOG2)));
  //wire isSaturated = OUT_WIDTH < maybeSaturated;
  //wire result = din / s**DIV_LOG2;

  //assign dout = isSaturated ? ((s**OUT_WIDTH)-1'b1) : result;
  /* NOTE: Takeaway of this problem is that division of 2^n = bit shift to the right by n
     10101010 / 10 = 10101010 >> 1 = 01010101
     11010011 / 100 = 11010011 >> 2 = 00110100 w/ remainder of 011
  */

  logic [OUT_WIDTH:0] temp; //OUT_WIDTH: = 32:0 which has an overflow bit
  //din[IN_WIDTH-1:DIV_LOG2] is the same thing as bit shifting to the right 3 times
  //This solves our division case
  // NOTE: This gets creative. Whenever you bit shift off for division, the remainder can help determine if you
  // round up or down. If 000, 001, 010, 011 -> round down. If 100, 101, 110, 111 -> round up. So use MSB of the remainder
  assign temp = din[IN_WIDTH-1:DIV_LOG2] + din[DIV_LOG2-1];
  //Check if our overflow bit is 1. If so, grab out max value. If not, we can grab the full size of temp
  assign dout = (temp[OUT_WIDTH] == 1 ? din[IN_WIDTH-1:DIV_LOG2] : temp[OUT_WIDTH-1:0]);


endmodule
