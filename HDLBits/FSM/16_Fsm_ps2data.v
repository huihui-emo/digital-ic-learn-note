module top_module(
    input clk,
    input [7:0] in,
    input reset,    // Synchronous reset
    output [23:0] out_bytes,
    output done
);

parameter IDLE = 0, S0 = 1, S1 = 2, S2 = 3;

reg [1:0] state, next;
reg [23:0] out;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        out   <= 24'b0;
    end else begin
        state <= next;

        case (state)
            IDLE: if (in[3]) out[23:16] <= in;
            S0:   out[15:8] <= in;
            S1:   out[7:0] <= in;
            S2:   if (in[3]) out[23:16] <= in;
        endcase
    end
end

always @(*) begin
    next = state;

    case (state)
        IDLE: next = in[3] ? S0 : IDLE;
        S0:   next = S1;
        S1:   next = S2;
        S2:   next = in[3] ? S0 : IDLE;
    endcase
end

assign done = (state == S2);
assign out_bytes = out;

endmodule
