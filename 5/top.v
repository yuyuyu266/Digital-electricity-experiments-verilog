module top(
    input clk,
    input reset_n,   // 新增：低电平复位输入 (P15)
    input [2:0] key, // key[2]=SW5(Pause), key[1]=SW6(Down), key[0]=SW7(Up)
    output [3:0] wei,
    output [7:0] duan,
    output [7:0] duan1,
    output       c_out
    );

    wire clk_scan;
    wire clk_cnt;
    wire [7:0] num;
    
    // 产生内部高电平复位信号
    // 如果 P15 是开关：拨下来(0)为复位，拨上去(1)为工作
    wire rst = ~reset_n; 

    // 实例化分频 (纯净时钟，不带 pause)
    fenpin u0 (
        .clk(clk),
        .rst(rst),          // 使用转换后的 rst
        .clk_scan(clk_scan),
        .clk_cnt(clk_cnt)
    );

    // 实例化计数器 (在内部处理 pause)
    counter_updown u1 (
        .clk(clk_cnt),
        .rst(rst),          // 使用转换后的 rst
        .key(key[1:0]), 
        .pause(key[2]),     // SW5 连接到这里
        .d_out(num),
        .c_out(c_out)
    );

    // 实例化 LED (显示部分)
    led u2 (
        .clk(clk_scan),
        .rst(rst),          // 使用转换后的 rst
        .key({key[0], key[1]}), 
        .d_in(num),
        .wei(wei),
        .duan(duan),
        .duan1(duan1)
    );

endmodule