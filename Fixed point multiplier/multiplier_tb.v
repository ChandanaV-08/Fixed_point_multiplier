
module testbench;

// Parameters
parameter CLK_PERIOD = 10; // Clock period in ns
parameter FILENAME = "input_signals.txt"; // Name of the input signals file

// Signals
reg clk = 0;
reg rst = 1;
reg signed [15:0] data_in_I, data_in_Q, mult_word;
wire signed [15:0] data_out_I, data_out_Q;

// Memory to hold the input data
reg [15:0] sine_mem [0:1023];   // Memory for sine values, max 1024 samples
reg [15:0] cosine_mem [0:1023]; // Memory for cosine values, max 1024 samples
integer i, file, num_samples, read_IO;

// Instantiate the module
FixedPointMultiplier uut (
    .clk(clk),
    .rst(rst),
    .data_in_I(data_in_I),
    .data_in_Q(data_in_Q),
    .mult_word(mult_word),
    .data_out_I(data_out_I),
    .data_out_Q(data_out_Q)
);

// Clock generation
always #CLK_PERIOD clk = ~clk;

// Test stimuli
initial begin
    $dumpfile("testbench.vcd");
    $dumpvars(0, testbench);

    // Reset
    rst = 1;
    #10;
    rst = 0;

    // Open the input file
    file = $fopen(FILENAME, "r");
    if (file == 0) begin
        $display("Failed to open file");
        $finish;
    end

    // Read data from file into memory
    i = 0;
    while (!$feof(file)) begin
        read_IO = $fscanf(file, "%b %b\n", sine_mem[i], cosine_mem[i]);
        if (read_IO == 2) begin
            i = i + 1;
        end
    end
    num_samples = i;
    $fclose(file);

    // Set multiplication factor
    mult_word = 16'd32767; // 1.0 in Q1.15 format

    // Apply inputs from the memory
    for (i = 0; i < num_samples; i = i + 1) begin
        data_in_I = sine_mem[i];
        data_in_Q = cosine_mem[i];
        #CLK_PERIOD;
    end

    // Wait for a little while before finishing
    #100;
    $finish;
end

endmodule
