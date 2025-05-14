module GrayCodeCounter #(
    parameter DATA_WIDTH = 4
) (
    input clk,
    input resetn,
    output logic [DATA_WIDTH-1:0] out
);
  logic [DATA_WIDTH-1:0] binary; //counter we are going to use to increment the sequence - binary -> graycode = MSB : gray[MSB] ^ bin[MSB-1] ...
  logic [DATA_WIDTH-1:0] gray;  // gray code representation


  always @(posedge clk) begin
    if (!resetn) begin
      binary <= 1;
      gray   <= 0;
    end else begin
      binary <= binary + 1;
      for (int i = 0; i < (DATA_WIDTH - 1); i = i + 1) begin
        gray[i] <= binary[i+1] ^ binary[i];
      end

      gray[DATA_WIDTH-1] <= binary[DATA_WIDTH-1];
    end
  end
  assign out = gray;

 // this is how to convert gray code to binary
 // always @(*) begin
 //  bin[DATA_WIDTH-1] = gray[DATA_WIDTH-1];
 //  for (int i = DATA_WIDTH - 2; i >= 0; i = i - 1) begin
 //     bin[i] = gray[i] ^ bin[i+1];
 //  end
 // end

endmodule
