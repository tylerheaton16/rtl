module DivideBy5 (
    input clk,
    input resetn,
    input din,
    output logic dout
);

  /*
  Num % 5 = 0 ---> divisible by 5
  */
  /*NOTE: This below is correct - HOWEVER, it is dependent on the size of sig1.
    this result will fail after 16 bit shifts. Therefore, is there a way for us to do this better?
    Yes...
    If we start with a value of 0, then 00 would imply we are still in our "no use state""
    if we see 01, then we know the value is "1" we know 1 is not divisible by 5, but it is divisible by 1
    Next, if we get 10, then 2 is divisible by 2. If 11, then 3 is divisible by 3.
    Next, if we get 100, then 4 is divisble by 4. If 101, then 5 is divisible by 5! (what we are looking for)
          or we get 110 where 6 is not divisible by 5, but we have a remainder of 1. Or 111 where 7 is not divisible by 5 but a remainder of 2
    Next, if we get 1000, and so on.

  */

  //reg [15:0] sig1;

  //assign dout = (sig1 % 5 == 0) && (sig1 != 0);

  //always @(posedge clk) begin
  //  if (~resetn) begin
  //    sig1 <= 0;
  //  end else begin
  //    sig1 <= (sig1 << 1) + din;
  //  end
  //end

  typedef enum {RE, MOD0, MOD1, MOD2, MOD3, MOD4} state_t ;
  //RE = remainder state
  state_t state;
  assign dout = (state == MOD5);

  always @(posedge clk) begin
    if (~resetn) begin
      state <= RE;
    end else begin
      case(state)
        RE: state <= din ? MOD1 : MOD0;
        MOD0: state <= din ? MOD1 : MOD0;
        MOD1: state <= din ? MOD3 : MOD2;
        MOD2: state <= din ? MOD0 : MOD4;
        MOD3: state <= din ? MOD1 : MOD1;
        MOD4: state <= din ? MOD4 : MOD3;
      endcase
    end
  end


endmodule
