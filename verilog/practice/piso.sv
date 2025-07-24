module piso #(parameter
  DATA_WIDTH = 4
) (
  input logic clk,
  input logic resetn,
  input logic [DATA_WIDTH-1:0] pin,
  input logic mode,
  output logic sout

);

  logic [DATA_WIDTH-1:0] par;
  /*
  when mode = 1, parallel shift in - 1 cycle
  when mode = 0, serial shit out - 4 cycles
  */

  always_ff @(posedge clk) begin
    if(~resetn) begin
      par <= 0;
    end else if (mode == 1) begin
      par <= pin;
    end else begin
      par <= par >> 1;
    end
  end

  always_comb begin
    sout = par[0];
  end


endmodule
