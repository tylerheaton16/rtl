module mux512to1_mux (
    input  wire [511:0] in,   // 512 single-bit inputs
    input  wire [  8:0] sel,  // 9-bit selector
    output wire         out   // selected output
);
  wire [255:0] level1;
  wire [127:0] level2;
  wire [ 63:0] level3;
  wire [ 31:0] level4;
  wire [ 15:0] level5;
  wire [  7:0] level6;
  wire [  3:0] level7;
  wire [  1:0] level8;

  genvar i;

  generate
    for (i = 0; i < 256; i = i + 1) assign level1[i] = sel[0] ? in[2*i+1] : in[2*i];
    for (i = 0; i < 128; i = i + 1) assign level2[i] = sel[1] ? level1[2*i+1] : level1[2*i];
    for (i = 0; i < 64; i = i + 1) assign level3[i] = sel[2] ? level2[2*i+1] : level2[2*i];
    for (i = 0; i < 32; i = i + 1) assign level4[i] = sel[3] ? level3[2*i+1] : level3[2*i];
    for (i = 0; i < 16; i = i + 1) assign level5[i] = sel[4] ? level4[2*i+1] : level4[2*i];
    for (i = 0; i < 8; i = i + 1) assign level6[i] = sel[5] ? level5[2*i+1] : level5[2*i];
    for (i = 0; i < 4; i = i + 1) assign level7[i] = sel[6] ? level6[2*i+1] : level6[2*i];
    for (i = 0; i < 2; i = i + 1) assign level8[i] = sel[7] ? level7[2*i+1] : level7[2*i];
  endgenerate

  assign out = sel[8] ? level8[1] : level8[0];

endmodule
