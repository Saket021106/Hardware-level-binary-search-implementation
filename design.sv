module binary_search_seq (
    input wire clk,
    input wire rst,
    input wire start,
    input wire [31:0] in [0:7], 
    input wire [31:0] key,
    output reg out,
    output reg done
);
    reg signed [4:0] left;
    reg signed [4:0] right;
    
    wire signed [4:0] mid;
    assign mid = (left + right) >>> 1; 
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            out   <= 1'b0;
            done  <= 1'b0;
            left  <= 5'sd0;
            right <= 5'sd7;
        end else if (start && !done) begin
            if (left <= right) begin
                if (in[mid] == key) begin
                    out  <= 1'b1;
                    done <= 1'b1;
                end else if (key > in[mid]) begin
                    left <= mid + 5'sd1;
                end else begin
                    right <= mid - 5'sd1;
                end
            end else begin
                out  <= 1'b0;
                done <= 1'b1;
            end
        end else if (!start) begin
            out   <= 1'b0;
            done  <= 1'b0;
            left  <= 5'sd0;
            right <= 5'sd7;
        end
    end
endmodule
