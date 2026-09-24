module top_module(
    input clk,
    input in,
    input reset,    // Synchronous reset
    output done
);
    parameter IDLE=0,S0=1,FAL=2,S1=3;
    reg [1:0] state,next;
    reg [3:0] count;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            count <= 0;
        end
        else begin
            state <= next;
            if (state != S0 && next == S0)
                count <= 0;
            else if (state == S0 && count <= 7)
                count <= count + 1;
        end
    end

    always @(*) begin
        next = state;
        case (state)
            IDLE: next = in ? IDLE : S0;
            S0:   next = (count <= 7) ? S0 : (in ? S1 : FAL);
            FAL:  next = in ? IDLE : FAL;
            S1:   next = in ? IDLE : S0;
            default: next = IDLE;
        endcase
    end

    assign done = (state == S1);
endmodule
