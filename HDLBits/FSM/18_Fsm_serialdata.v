module top_module (
    input clk,
    input in,
    input reset,    // Synchronous reset
    output reg [7:0] out_byte,
    output reg done
); //
    parameter IDLE=0,DATA=1,STOP=2,WAIT=3;
    reg [1:0] state;
    reg [2:0] count;
    reg [7:0] out;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            count <= 0;
            done <= 0;
            out <= 0;
            out_byte <= 0;
        end else begin
            done <= 0;
            case (state)
                IDLE: if (!in) state <= DATA;

                DATA: begin
                    out[count] <= in;
                    if (count == 7) begin
                        state <= STOP;
                        count <= 0;
                        out[7] <= in;
                    end else
                        count <= count + 1;
                end

                STOP: begin
                    if (in) begin
                        state <= IDLE;
                        done <= 1;
                        out_byte <= out;
                    end else
                        state <= WAIT;
                end

                WAIT: if (in) state <= IDLE;

                default: begin
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule
