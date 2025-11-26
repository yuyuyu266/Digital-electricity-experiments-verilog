module fenpin(
    input clk,
    input rst,
    output reg clk_scan,  
    output reg clk_cnt    
    );

    reg [31:0] cnt1;
    reg [31:0] cnt2;

    // 1kHz 扫描时钟
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            cnt1 <= 0;
            clk_scan <= 0;
        end
        else if(cnt1 >= 49999) begin
            cnt1 <= 0;
            clk_scan <= ~clk_scan;
        end
        else cnt1 <= cnt1 + 1;
    end

    // 2Hz 计数时钟
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            cnt2 <= 0;
            clk_cnt <= 0;
        end
        else if(cnt2 >= 24999999) begin
            cnt2 <= 0;
            clk_cnt <= ~clk_cnt;
        end
        else cnt2 <= cnt2 + 1;
    end
endmodule