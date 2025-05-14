module clk_divider #(
    parameter WIDTH = 32
) (
    input  wire             clk,
    input  wire             rst,
    input  wire [WIDTH-1:0] n,       // divide factor
    output reg              clk_out
);

  reg [WIDTH-1:0] count;

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      count   <= 0;
      clk_out <= 0;
    end else begin
      if (count == n - 1) begin
        count   <= 0;
        clk_out <= ~clk_out;
      end else begin
        count <= count + 1;
      end
    end
  end

endmodule
