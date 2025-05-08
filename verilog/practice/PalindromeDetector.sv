module PalindromeDetector #(parameter
  DATA_WIDTH=32
) (
  input [DATA_WIDTH-1:0] din,
  output logic dout
);

//palindrome example 10001 or all 1s is a palindrome
reg isNotPalindrome;
always@(*) begin
  isNotPalindrome = 1; // assume it is a palindrome unless it isn't
  for(int i=0; i < DATA_WIDTH/2; i++) begin
    if(din[i] != din[DATA_WIDTH-i-1]) begin
      isNotPalindrome = 0;
    end
  end
  dout = isNotPalindrome;
end

endmodule
