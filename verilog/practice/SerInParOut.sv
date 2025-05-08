module SerInParOut #(
    parameter DATA_WIDTH = 16
) (
    input clk,
    input resetn,
    input din,
    output logic [DATA_WIDTH-1:0] dout
);

  reg [DATA_WIDTH-1:0] result;

  always@(posedge clk) begin
    if(~resetn) begin
      result <= 0;
    end else begin
      result <= (result << 1) + din;
    end
  end

  assign dout = result;

endmodule

