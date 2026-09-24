module FSM_serialdp (
    input  wire       clk,
    input  wire       in,
    input  wire       reset,     // Synchronous, active-high reset
    output reg  [7:0] out_byte,
    output reg        done
);

    localparam IDLE   = 3'd0;
    localparam DATA   = 3'd1;
    localparam PARITY = 3'd2;
    localparam STOP   = 3'd3;
    localparam WAIT   = 3'd4;

    reg [2:0] state;
    reg [2:0] count;
    reg [7:0] data_buffer;

    wire odd;
    wire parity_reset;

    // Accumulate parity only while receiving the data and parity bits.
    assign parity_reset = reset || !((state == DATA) || (state == PARITY));

    parity parity_inst (
        .clk   (clk),
        .reset (parity_reset),
        .in    (in),
        .odd   (odd)
    );

    always @(posedge clk) begin
        if (reset) begin
            state       <= IDLE;
            count       <= 3'd0;
            done        <= 1'b0;
            data_buffer <= 8'd0;
            out_byte    <= 8'd0;
        end else begin
            done <= 1'b0;

            case (state)
                IDLE: begin
                    if (!in)
                        state <= DATA;
                end

                DATA: begin
                    data_buffer[count] <= in;

                    if (count == 3'd7) begin
                        state <= PARITY;
                        count <= 3'd0;
                    end else begin
                        count <= count + 1'b1;
                    end
                end

                PARITY: begin
                    state <= STOP;
                end

                STOP: begin
                    if (in) begin
                        state <= IDLE;

                        if (odd) begin
                            done     <= 1'b1;
                            out_byte <= data_buffer;
                        end
                    end else begin
                        state <= WAIT;
                    end
                end

                WAIT: begin
                    if (in)
                        state <= IDLE;
                end

                default: begin
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule


// Tracks whether the number of sampled 1 bits is odd.
module parity (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  odd
);

    always @(posedge clk) begin
        if (reset)
            odd <= 1'b0;
        else if (in)
            odd <= ~odd;
    end

endmodule
