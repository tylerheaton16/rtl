module SyncFifo_tb (  /*AUTOARG*/);
  parameter int WIDTH = 64;
  parameter int DEPTH = 8;
  /*AUTOLOGIC*/
  // Beginning of automatic wires (for undeclared instantiated-module outputs)
  logic [WIDTH-1:0]     dout;                   // From s_fifo of SyncFifo.v
  logic                 empty;                  // From s_fifo of SyncFifo.v
  logic                 full;                   // From s_fifo of SyncFifo.v
  // End of automatics
  /*AUTOREGINPUT*/
  // Beginning of automatic reg inputs (for undeclared instantiated-module inputs)
  logic                 clk;                    // To s_fifo of SyncFifo.v
  logic [WIDTH-1:0]     din;                    // To s_fifo of SyncFifo.v
  logic                 ren;                    // To s_fifo of SyncFifo.v
  logic                 reset;                  // To s_fifo of SyncFifo.v
  logic                 wen;                    // To s_fifo of SyncFifo.v
  // End of automatics

  logic [WIDTH-1:0] wdata_q[$], wdata;
  logic [63:0] rand64;

  SyncFifo #(  /*AUTOINSTPARAM*/
             // Parameters
             .DEPTH                     (DEPTH),
             .WIDTH                     (WIDTH))
  s_fifo (  /*AUTOINST*/
          // Outputs
          .full                         (full),
          .empty                        (empty),
          .dout                         (dout[WIDTH-1:0]),
          // Inputs
          .clk                          (clk),
          .reset                        (reset),
          .wen                          (wen),
          .ren                          (ren),
          .din                          (din[WIDTH-1:0]));
  always #5ns clk = ~clk;

  initial begin

  end

  initial begin
    clk = 1'b0; reset = 1'b0;
    wen = 1'b0;
    din = 0;

    repeat(10) @(posedge clk);
    reset = 1'b1;

    repeat(2) begin
      for (int i=0; i<30; i++) begin
        @(posedge clk);
        wen = (i%2 == 0)? 1'b1 : 1'b0;
        rand64 = { $urandom, $urandom };
        if (wen & !full) begin
          din = rand64;
          wdata_q.push_back(din);
        end
      end
      #50;
    end
  end

  initial begin
    clk = 1'b0; reset = 1'b0;
    ren = 1'b0;

    repeat(20) @(posedge clk);
    reset = 1'b1;

    repeat(2) begin
      for (int i=0; i<30; i++) begin
        @(posedge clk);
        ren = (i%2 == 0)? 1'b1 : 1'b0;
        if (ren & !empty) begin
          #1;
          wdata = wdata_q.pop_front();
          if(dout !== wdata) $error("Time = %0t: Comparison Failed: expected wr_data = %h, rd_data = %h", $time, wdata, dout);
          else $display("Time = %0t: Comparison Passed: wr_data = %h and rd_data = %h",$time, wdata, dout);
        end
      end
      #50;
    end

    $finish;
  end
endmodule

