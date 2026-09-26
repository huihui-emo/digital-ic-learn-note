module top_module (
    input clk,
    input reset,    // Synchronous reset
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    localparam DATA = 0, FLAG = 1, ERR = 2;

    reg [1:0] state;
    reg [2:0] count;

    always @(posedge clk) begin
        if (reset) begin
            state <= DATA;
            disc  <= 0;
            flag  <= 0;
            err   <= 0;
            count <= 0;
        end else begin
            disc <= 0;
            flag <= 0;
            err  <= 0;

            case (state)
                DATA: begin
                    if (!in) begin
                        if (count == 5)
                            disc <= 1;
                        count <= 0;
                    end else begin
                        if (count == 5) begin
                            state <= FLAG;
                            count <= 0;
                        end else begin
                            count <= count + 1'b1;
                        end
                    end
                end

                FLAG: begin
                    if (in) begin
                        state <= ERR;
                        err   <= 1;
                    end else begin
                        state <= DATA;
                        flag  <= 1;
                    end
                end

                ERR: begin
                    if (!in)
                        state <= DATA;
                    else
                        err <= 1;
                end

                default: begin
                    state <= DATA;
                    count <= 0;
                end
            endcase
        end
    end

endmodule
