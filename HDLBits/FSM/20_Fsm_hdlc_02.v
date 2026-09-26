module top_module (
    input clk,
    input reset,    // Synchronous reset
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    reg [2:0] count;

    always @(posedge clk) begin
        if (reset) begin
            count <= 0;
            disc  <= 0;
            flag  <= 0;
            err   <= 0;
        end else begin
            // 根据之前连续的 1 的数量，以及当前输入，更新输出
            disc <= !in && (count == 5);
            flag <= !in && (count == 6);
            err  <=  in && (count >= 6);

            // 更新连续的 1 的数量，计数到 7 后保持
            if (!in)
                count <= 0;
            else if (count < 7)
                count <= count + 1'b1;
        end
    end

endmodule
