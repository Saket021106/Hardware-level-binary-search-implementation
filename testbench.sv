`timescale 1ns/1ps

module tb_binary_search_seq;

    reg clk;
    reg rst;
    reg start;
    reg [31:0] in [0:7];
    reg [31:0] key;
    wire out;
    wire done;

    wire [31:0] in_0 = in[0];
    wire [31:0] in_1 = in[1];
    wire [31:0] in_2 = in[2];
    wire [31:0] in_3 = in[3];
    wire [31:0] in_4 = in[4];
    wire [31:0] in_5 = in[5];
    wire [31:0] in_6 = in[6];
    wire [31:0] in_7 = in[7];

    binary_search_seq dut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .in(in),
        .key(key),
        .out(out),
        .done(done)
    );

    always #5 clk = ~clk; 

    task run_search(input [31:0] search_key, input expected_out);
        begin
            $display("[%0t] Searching for key: %0d...", $time, search_key);
            key = search_key;
            start = 1;
            
            while (!done) @(posedge clk);
            
            if (out === expected_out) begin
                $display(" ---> [PASS] Key: %0d | Found: %0b", search_key, out);
            end else begin
                $error(" ---> [FAIL] Key: %0d | Found: %0b (Expected: %0b)", search_key, out, expected_out);
            end
            
            start = 0;
            @(posedge clk);
            @(posedge clk);
        end
    endtask

    initial begin
        clk = 0;
        rst = 1;
        start = 0;
        key = 0;
        
        in = '{10, 25, 33, 42, 59, 71, 88, 95};
        
        @(posedge clk);
        rst = 0;
        @(posedge clk);
        $display("--- Starting Binary Search Tests ---");
        $display("Array: {10, 25, 33, 42, 59, 71, 88, 95}\n");

        run_search(42, 1); 
        run_search(10, 1); 
        run_search(95, 1); 
        run_search(59, 1); 
        
        run_search(5, 0);  
        run_search(100, 0); 
        run_search(30, 0); 

        $display("\n--- All Tests Completed ---");
        
        $finish;
    end

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_binary_search_seq);
    end

endmodule
