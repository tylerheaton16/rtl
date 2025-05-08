module CountingOnes #(
    parameter DATA_WIDTH = 16
) (
    input [DATA_WIDTH-1:0] din,
    output logic [$clog2(DATA_WIDTH):0] dout
);
  int i;
  reg [$clog2(DATA_WIDTH):0] temp;
  assign dout = temp;
  always @(*) begin
    for (i = 0; i < DATA_WIDTH; i = i + 1) begin
      if (din[i] == 0) begin
        temp = temp;
      end else begin
        temp = temp + 1;
      end
    end
  end

endmodule
