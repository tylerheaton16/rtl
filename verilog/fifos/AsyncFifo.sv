module AsyncFifo #(
    parameter W = 8,
    parameter DEPTH = 8
) (
    input wclk,
    input rclk,
    input wrst_n,
    input rrst_n,
    input w_en,
    input r_en,
    output full,
    output empty,
    input logic [W-1:0] data_in,
    output logic [W-1:0] data_out

);

  logic [W-1:0] fifo[DEPTH];  // NOT depth-1 because we can look at if
  // want pointer to be 1 additional bit larger
  // pointer size is a function of depth size
  //depth = $clog2(8) = 3 3-1:0 2:0. 3
  //$clog2(8) = 3 3:0
  localparam PTR_SIZE = $clog2(DEPTH);

  logic isMsbOne;
  logic [PTR_SIZE:0] wtPtr;
  logic [PTR_SIZE:0] rdPtr;
  logic [PTR_SIZE:0] wtPtr_Sync;
  logic [PTR_SIZE:0] rdPtr_Sync;
  logic [PTR_SIZE:0] wtPtr_Gray;
  logic [PTR_SIZE:0] rdPtr_Gray;


  /*
    write side, we are synchronous with wtPtr, must SYNC in rdPtr
    read side, we are synchronous with rdPtr, must SYNC in the wtPtr
  */

  always_comb begin
    isMsbOne = wtPtr[PTR_SIZE] ^ rdPtr_Sync[PTR_SIZE];
    empty = rdPtr == wtPtr_Sync;
    full = isMsbOne && wtPtr[PTR_SIZE-1:0] == rdPtr_Sync[PTR_SIZE-1:0];
  end

  always_ff @(posedge wclk) begin
    if(~wrst_n) begin
    end else begin
    end
  end

  always_ff @(posedge rclk) begin
    if(~rrst_n) begin
    end else begin
    end
  end

  //write -> read domain (wtPtr)
  b2g #(.CODE_SIZE (PTR_SIZE)) b2g_inst (
    .bin (wtPtr),
    .gray (wtPtr_Gray)
  );

  DualFFSync #(.W (PTR_SIZE)) wtSync (
    .clk (rclk),
    .rstn (rrst_n),
    .d_in (wtPtr_Gray),
    .q_sync (wtPtr_Sync)
  );

  //read -> write domain (rdPtr)
  b2g #(.CODE_SIZE (PTR_SIZE)) b2g_inst2 (
    .bin (rdPtr),
    .gray (rdPtr_Gray)
  );

  DualFFSync #(.W (PTR_SIZE)) rdSync (
    .clk (wclk),
    .rstn (wrst_n),
    .d_in (rdPtr_Gray),
    .q_sync (rdPtr_Sync)
  );

  //2FF for syncing pointers
  //b2g and g2b to convert to gray before syncing
endmodule

module DualFFSync #(
    parameter W = 8
) (
    input clk,
    input rstn,
    input [W-1:0] d_in,
    output [W-1:0] q_sync
);

  logic [W-1:0] d_meta;

  always_ff @(posedge clk) begin
    if (~resetn) begin
      q_out  <= 0;
      d_meta <= 0;
    end else begin
      d_meta <= d_in;
      q_out  <= d_meta;
    end
  end

endmodule

module b2g #(
    parameter CODE_SIZE = 8
) (
    input  [CODE_SIZE-1:0] bin,
    output [CODE_SIZE-1:0] gray
);

  // g[i] = b[i+1] ^ b[i]
  // g = b ^ (b >> 1)

  always_comb begin
    gray = bin ^ (bin >> 1);
  end
endmodule

module g2b #(
    parameter CODE_SIZE = 8
) (
    input  [CODE_SIZE-1:0] gray,
    output [CODE_SIZE-1:0] bin
);

  always_comb begin
    bin[CODE_SIZE-1] = gray[CODE_SIZE-1];

    for (int i = 0; i < CODE_SIZE - 2; i++) begin
      //bin[i] = b[i+1] ^ g[i]
      bin[i] = bin[i+1] ^ gray[i];
    end
  end
endmodule
