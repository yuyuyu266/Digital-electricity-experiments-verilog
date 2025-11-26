module counter_updown(
    input clk,
    input rst,
    input [1:0] key, // UP/DOWN
    input pause,     // SW5 暂停信号
    output reg [7:0] d_out,
    output reg       c_out
    );

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            d_out <= 8'd02; // 复位值
            c_out <= 1'b0;
        end
        else begin
            c_out <= 1'b0;

            // 1. 暂停检查
            if (pause) begin
                d_out <= d_out; // 保持不变
            end
            // 2. 互斥检查 (同时按)
            else if (key[0] == 1 && key[1] == 1) begin
                d_out <= d_out;
            end
            // 3. 向上计数 (UP)
            else if(key[0] == 1) begin 
                if(d_out >= 11) begin
                    d_out <= 8'd02;
                    c_out <= 1'b1;
                end
                else begin
                    d_out <= d_out + 1;
                end
            end
            // 4. 向下计数 (DOWN)
            else if(key[1] == 1) begin 
                if(d_out <= 2) begin 
                    d_out <= 8'd11;
                    c_out <= 1'b1;
                end
                else begin
                    d_out <= d_out - 1;
                end
            end
        end
    end
endmodule