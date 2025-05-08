module FibonacciSequence #(
    parameter N = 16
) (
    input clk,
    input resetn,
    output [N-1:0] out
);

  reg [N-1:0] fib_prev, fib_cur;

  always@(posedge clk) begin
    if(~resetn) begin
      fib_cur <= 1;
      fib_prev <= 0;
    end else begin
      fib_cur <= fib_cur + fib_prev;
      fib_prev <= fib_cur;
    end
  end
endmodule
