module top_module (
    input clk,
    input in,
    input reset,    // Synchronous reset
    output reg done
);

    parameter IDLE = 2'd0, DATA = 2'd1,
              STOP = 2'd2, WAIT = 2'd3;

    reg [1:0] state;
    reg [2:0] count;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            count <= 3'd0;
            done  <= 1'b0;
        end else begin
            done <= 1'b0;

            case (state)
                IDLE: begin
                    if (!in)
                        state <= DATA;
                end

                DATA: begin
                    if (count == 3'd7) begin
                        state <= STOP;
                        count <= 3'd0;
                    end else begin
                        count <= count + 1'b1;
                    end
                end

                STOP: begin
                    if (in) begin
                        state <= IDLE;
                        done  <= 1'b1;
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
                    count <= 3'd0;
                end
            endcase
        end
    end

endmodule
