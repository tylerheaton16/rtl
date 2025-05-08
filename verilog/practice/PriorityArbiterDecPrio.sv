module PriorityArbiterDecPrio #(
    parameter N = 32
) (
    input  [N-1:0] req,
    output [N-1:0] gnt,
    input  [N-1:0] req_msb,
    output [N-1:0] gnt_msb
);

  /*
  An arbiter gets a request that looks like 1010...001
  If the LSB has priority, then req[0] will always get priority
  There will always be a bit which has the higher priority - LSB for this example
  lets paramaterize it
  */
  //logic [N-1:0] prio_req;
  ////lets take this priority request signal and assign bit 0 to 0
  //assign prio_req[0] = 1'b0; // LSB will always have the highest priority

  //genvar i;
  //for (i=0; i < N-1; i++) begin
  //  //prio_req[1] = prio_req[0] | req[0]
  //  //req       = 1010
  //  //prio_req  = 1100
  //  //~prio_req = 0011
  //  //gnt = req & ~prio_req = 1010 & 0011 = 0010
  //end
  //NOTE: We can optimize this to get rid of prio_req and just assign to the grant signal
  assign gnt[0] = req[0];

  for (genvar i = 1; i < N; i++) begin
    assign gnt[i] = req[i] & ~(|req[i-1:0]);
    // NOTE: We basically just pad 0s onto gnt if any past req value was 1.
  end

  //for MSB

  assign gnt_msb[N-1] = req_msb[N-1];

  for (genvar i = 2; i < N - 1; i++) begin
    assign gnt[N-i] = req[N-i] & ~(|req[N-1:N-i]);
  end

  //NOTE: The commong way to create a priority arbiter
  //Say N = 8
  //logic [N-1:0] higher_pri_req;
  //assign higher_pri_req[0] = 1'b0;  //LSB has the highest priority
  //for (genvar i = 0; i < N - 1; i++) begin
  //  assign higher_pri_req[i+1] = higher_pri_req[i] | req[i];
  //end
  //assign gnt[N-1:0] = req[N-1:0] & ~higher_pri_req[N-1:0];

endmodule
