module model #(
    parameter DATA_WIDTH = 16
) (
    input clk,
    input resetn,
    input [DATA_WIDTH-1:0] din,
    input din_en,
    output logic dout
);
  /*
  1) shift LSB out to dout one at a time
  2) Shift when din_en is high
  3) If all bits have been shifted out, output 0 - bit shifting to the bright handles that
  */

  //reg [DATA_WIDTH-1:0] din_r;

  //always @(posedge clk) begin
  //  if (~resetn) begin
  //    din_r <= din;
  //  end else if (din_en) begin
  //    dout  <= din_r[0];
  //    din_r <= din >> 1;
  //  end
  //end
  //assign dout = din_r[0];

  reg [DATA_WIDTH-1:0] din_r;

  always @(posedge clk) begin
    if (~resetn) begin
      din_r <= 0;
    end else if (din_en) begin
      din_r <= din;
    end else begin
      din_r <= din_r >> 1;
    end
  end
  assign dout = din_r[0];


endmodule
