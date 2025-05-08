module RoundRobinArbiter #(
    parameter N = 8
) (
    input [N-1:0] req,
    input [$clog2(N)-1:0] req_pnt,
    output [N-1:0] gnt

);
  //Round robin arbiter uses a priority arbiter and a "rotate" block
  /*
  req -> rotate -> prio arbiter -> rotate -> gnt
           ^                          ^
           |                          |
  ------req_pnt -----------------------

  The pointer is incremented which switches the prio order
  */
  wire [N*2-1:0] double_req;
  wire [  N-1:0] req2;
  wire [  N-1:0] gnt_prio;
  wire [N*2-1:0] gnt_prio_double;

  //rotate 1
  assign double_req = {req[N-1:0], req[N-1:0]} >> req_pnt;
  assign req2 = double_req[N-1:0];

  //priority arbiter
  assign gnt_prio[0] = req2[0];
  for (genvar i = 1; i < N; i++) begin
    assign gnt_prio[i] = req2[i] & ~(|req2[i-1:0]);
  end

  //rotate 2
  assign gnt_prio_double = {gnt_prio[N-1:0], gnt_prio[N-1:0]} << req_pnt;
  assign gnt = gnt_prio_double[N-1:0];

endmodule
