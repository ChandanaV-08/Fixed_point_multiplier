

module FixedPointMultiplier (
    input clk,       // Clock signal
    input rst,       // Reset signal
    input signed [15:0] data_in_I, // Input data I
    input signed [15:0] data_in_Q, // Input data Q
    input signed [15:0] mult_word, // Multiplication factor
    output reg signed [15:0] data_out_I, // Output data I
    output reg signed [15:0] data_out_Q // Output data Q
);

reg signed [31:0] product_I, product_Q;

always @(posedge clk or posedge rst)
begin
    if (rst)
       begin
           // Reset outputs
           data_out_I <= 16'b0;
           data_out_Q <= 16'b0;
       end 
       
       else 
       begin
       
        // Perform fixed-point multiplication
        product_I <= data_in_I * mult_word;
        product_Q <= data_in_Q * mult_word;
        // Truncate to 16 bits and preserve sign
        data_out_I <= product_I[30-:15] >> 1;
        data_out_Q <= product_Q[30:15] >> 1;
    end
end

endmodule


