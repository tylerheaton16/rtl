module TrailingZeroes#(parameter
  DATA_WIDTH = 32
) (
  input  [DATA_WIDTH-1:0] din,
  output logic [$clog2(DATA_WIDTH):0] dout
);
reg found;
reg  [$clog2(DATA_WIDTH+1)-1:0] count;
always @(*) begin
    count = 0;
    found = 0;
    for (int i = 0; i < DATA_WIDTH; i = i + 1) begin
        if (!found) begin
            if (din[i] == 1'b0)
                count = count + 1;
            else
                found = 1; // stop counting on first '1'
        end
    end
    if (din == 0)
        count = DATA_WIDTH;

    assign dout = count;
end
endmodule
