module ToggleSynchronizer (
  input sig1,
  input clkA,
  input clkB,
  input resetn,
  output wire sig_sync

);

  reg a1_q, b1_q, b2_q, b3_q;
  wire a1_d;

  assign a1_d = sig1 ? ~a1_q : a1_q;
  assign sig_sync = b2_q ^ b3_q;

  always@(posedge clkA) begin
    if(~resetn) begin
      a1_q <= 0;
    end else begin
      a1_q <= a1_d;
    end
  end

  always@(posedge clkB) begin
    if(~resetn) begin
      b1_q <= 0;
      b2_q <= 0;
      b3_q <= 0;
    end else begin
      b1_q <= a1_d;
      b2_q <= b1_q;
      b3_q <= b2_q;
    end
  end

endmodule
