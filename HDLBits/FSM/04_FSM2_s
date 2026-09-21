module top_module(
    input clk,
    input reset,    // Synchronous reset to OFF
    input j,
    input k,
    output out); //  

    parameter OFF=0, ON=1; 
    reg state, next_state;

    always @(*) begin
        case(state)
            OFF: if(j) next_state=ON;
            	 else next_state=OFF;
            ON: if(k) next_state=OFF;
            else next_state=ON;
        endcase
    end

    always @(posedge clk) begin
        if(reset) state<=OFF;
        else state<=next_state;
    end
    
    assign out=(state==ON)?1:0;

endmodule
