module EdgeDetector (
  input clk,
  input resetn,
  input din,
  output dout
);

  typedef enum {ZZ, ZO, OZ, OO} edgedetector_t;
  edgedetector_t state;

  always@(posedge clk) begin
    if(~resetn) begin
      state <= ZZ;
    end else begin
      case(state)
        ZZ: state <= din ? ZO : ZZ;
        ZO: state <= din ? OO : OZ;
        OZ: state <= din ? ZO : ZZ;
        OO: state <= din ? OO : OZ;
      endcase
    end
  end
  assign dout = (state == OZ);
endmodule
