module top_module(clk, reset, in, out);
    input clk;
    input reset;    // Synchronous reset to state B
    input in;
    output out;//  
    reg out;

    // Fill in state name declarations
	parameter A=0,B=1;
    reg state, next_state;

   always @(*) begin    // This is a combinational always block
        case(state)
            A: if(in) next_state=A;
               else next_state=B;
            B: if(in) next_state=B;
               else next_state=A;
        endcase
    // State transition logic
    end

    always @(posedge clk) begin    // This is a sequential always block
        if(reset) state<=B;
        else state<=next_state;// State flip-flops with asynchronous reset
    end

    assign out=(state==B)?1'b1:1'b0;

endmodule
