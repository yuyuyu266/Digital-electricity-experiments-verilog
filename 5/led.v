module led(
    input clk,             // 1kHz 扫描时钟
    input rst,
    input [1:0] key,       // 这里借用 key 输入来表示状态: 10=Up, 01=Down
    input [7:0] d_in,      // 计数值
    output reg led,
    output reg [3:0] wei,  // 位选
    output reg [7:0] duan,  // 段选
    output reg [7:0] duan1  // 段选
    );

    reg [1:0] wei_cnt;
    reg [3:0] data;    // --- 第一部分：位选扫描 (完全参考 PPT 截图 1) ---
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            wei_cnt <= 2'd0;
        end
        else begin
            wei_cnt <= wei_cnt + 1'b1;
        end
    end

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            wei <= 4'd0;
            data <= 4'd0;
        end
        else begin
            case(wei_cnt)
                // PPT 逻辑：wei 输出高电平(1) 选中
                2'b00: begin 
                    wei <= 4'b0001;      // 对应 XDC 的 wei[0] (H1)
                    data <= d_in % 10;   // 个位
                end
                2'b01: begin 
                    wei <= 4'b0010;      // 对应 XDC 的 wei[1] (C1)
                    data <= d_in / 10;   // 十位
                end
                2'b10: begin 
                    wei <= 4'b0100;      // 对应 XDC 的 wei[2] (C2)
                    // 这里原本 PPT 是 data <= 4'd5; 
                    // 为了完成实验，改为显示 U 或 d
                    if(key == 2'b10)      data <= 4'd10; // U
                    else if(key == 2'b01) data <= 4'd11; // d
                    else                  data <= 4'd12; // -
                end
                2'b11: begin 
                    wei <= 4'b1000;      // 对应 XDC 的 wei[3] (G2)
                    data <= 4'd13;       // 不显示
                end
            endcase
        end
    end

    always @(data) begin
        case(data)
            4'b0000: begin duan <= 8'b11111100; duan1 <= 8'b11111100; end//0
            4'b0001: begin duan <= 8'b01100000; duan1 <= 8'b01100000; end// 1
            4'b0010: begin duan <= 8'b11011010; duan1 <= 8'b11011010; end// 2
            4'b0011: begin duan <= 8'b11110010; duan1 <= 8'b11110010; end// 3
            4'b0100: begin duan <= 8'b01100110; duan1 <= 8'b01100110; end// 4
            4'b0101: begin duan <= 8'b10110110; duan1 <= 8'b10110110; end// 5
            4'b0110: begin duan <= 8'b10111110; duan1 <= 8'b10111110; end// 6
            4'b0111: begin duan <= 8'b11100000; duan1 <= 8'b11100000; end// 7
            4'b1000: begin duan <= 8'b11111110; duan1 <= 8'b11111110; end// 8
            4'b1001: begin duan <= 8'b11110110; duan1 <= 8'b11110110; end// 9
            
            4'd10:   begin duan <= 8'b01111100; duan1 <= 8'b01111100; end// U (bcdef 亮)
            4'd11:   begin duan <= 8'b01111010; duan1 <= 8'b01111010; end// d (bcdeg 亮)
            4'd12:   begin duan <= 8'b00000010; duan1 <= 8'b00000010; end// - (g 亮)
            default: begin duan <= 8'b00000000; duan1 <= 8'b00000000; end// 全灭
        endcase
    end

endmodule