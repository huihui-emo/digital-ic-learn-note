module top_module(
    input clk,
    input [7:0] in,
    input reset,    // Synchronous reset
    output done
);

parameter IDLE = 0, S0 = 1, S1 = 2, S2 = 3;
reg [1:0] state, next;

// State flip-flops
always @(posedge clk) begin
    if (reset)
        state <= IDLE;
    else
        state <= next;
end

// State transition logic
always @(*) begin
    next = state;

    case (state)
        IDLE: next = in[3] ? S0 : IDLE;
        S0:   next = S1;
        S1:   next = S2;
        S2:   next = in[3] ? S0 : IDLE;
        default: next = IDLE;
    endcase
end

// Output logic
assign done = (state == S2);

endmodule
