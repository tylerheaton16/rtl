module sipo#(parameter
  DATA_WIDTH = 4
) (
  input logic clk,
  input logic resetn,
  input logic sin,
  input logic mode,
  output logic [DATA_WIDTH-1:0] pout

);

  localparam cntMsb = $clog2(DATA_WIDTH);
  logic [$clog2(DATA_WIDTH):0] cnt;
  logic [DATA_WIDTH-1:0] pout_r;

  always_ff @(posedge clk) begin
    if(~resetn) begin
      pout_r <= 0;
      cnt <= 0;
    end else if (cnt[cntMsb] == 1) begin
      cnt <= 0;
    end else begin
      cnt <= cnt + 1;
      pout_r <= {pout_r[DATA_WIDTH-2:0], sin};
    end
  end

  always_comb begin
    pout = cnt[cntMsb] == 1 ? pout_r : 0;
  end
endmodule
