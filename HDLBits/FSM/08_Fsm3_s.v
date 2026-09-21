module top_module(
    input clk,
    input in,
    input reset,
    output out); //
	
    parameter A=2'd0,B=2'd1,C=2'd2,D=2'd3;
    reg [1:0]state,next_state;
    always@(posedge clk )
        begin
            if(reset) state<=2'd0;
            else state<=next_state;
        end
    always@(*)begin
        case(state)
            A: if(in) next_state=B;
            else next_state=A;
            B: if(in) next_state=B;
            else next_state=C;
            C: if(in) next_state=D;
            else next_state=A;
            D: if(in) next_state=B;
            else next_state=C;
        endcase
    end
    assign out=(state==D);// State transition logic

    // State flip-flops with synchronous reset

    // Output logic

endmodule
