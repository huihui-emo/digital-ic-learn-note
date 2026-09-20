module top_module_1 (
    input clk,
    input reset,
    input [3:1] s,
    output reg fr3,
    output reg fr2,
    output reg fr1,
    output reg dfr
); 
    parameter BS1=3'd0,S12_U=3'd1,S12_D=3'd2,S23_U=3'd3,S23_D=3'd4,AS3=3'd5;
    reg [2:0] state,next_state;
    always@(posedge clk)begin
        if(reset) state<=BS1;
        else state<=next_state;
    end
    always@(*)begin
       
        case(state)
            BS1: begin {fr3,fr2,fr1,dfr}=4'b1111;
                if(s==3'b001)  next_state=S12_U;
                else if(s==3'b000) next_state=BS1;
            end
            S12_U: begin {fr3,fr2,fr1,dfr}=4'b0110;
                if(s==3'b011) next_state=S23_U;
                else if(s==3'b000) next_state=BS1;
                else if(s==3'b001) next_state=S12_U;
            end
            S12_D:begin {fr3,fr2,fr1,dfr}=4'b0111;
                 if(s==3'b011) next_state=S23_U;
                else if(s==3'b000) next_state=BS1;
                else if(s==3'b001) next_state=S12_D;
            end
            S23_U:begin {fr3,fr2,fr1,dfr}=4'b0010;
                if(s==3'b111) next_state=AS3;
                else if(s==3'b001) next_state=S12_D;
                else if(s==3'b011) next_state=S23_U;
            end
            S23_D:begin {fr3,fr2,fr1,dfr}=4'b0011;
                if(s==3'b111) next_state=AS3;
                else if(s==3'b001) next_state=S12_D;
                else if(s==3'b011) next_state=S23_D;
            end
            AS3:begin {fr3,fr2,fr1,dfr}=4'b0000;
                if(s==3'b011) next_state=S23_D;
                else if(s==3'b111) next_state=AS3;
            end
        endcase
    end
                    
                    
endmodule

module top_module_2 (
	input clk,
	input reset,
	input [3:1] s,
	output reg fr3,
	output reg fr2,
	output reg fr1,
	output reg dfr
);


	// Give state names and assignments. I'm lazy, so I like to use decimal numbers.
	// It doesn't really matter what assignment is used, as long as they're unique.
	// We have 6 states here.
	parameter A2=0, B1=1, B2=2, C1=3, C2=4, D1=5;
	reg [2:0] state, next;		// Make sure these are big enough to hold the state encodings.
	


    // Edge-triggered always block (DFFs) for state flip-flops. Synchronous reset.	
	always @(posedge clk) begin
		if (reset) state <= A2;
		else state <= next;
	end



    // Combinational always block for state transition logic. Given the current state and inputs,
    // what should be next state be?
    // Combinational always block: Use blocking assignments.    
	always@(*) begin
		case (state)
			A2: next = s[1] ? B1 : A2;
			B1: next = s[2] ? C1 : (s[1] ? B1 : A2);
			B2: next = s[2] ? C1 : (s[1] ? B2 : A2);
			C1: next = s[3] ? D1 : (s[2] ? C1 : B2);
			C2: next = s[3] ? D1 : (s[2] ? C2 : B2);
			D1: next = s[3] ? D1 : C2;
			default: next = 'x;
		endcase
	end
	
	
	
	// Combinational output logic. In this problem, a procedural block (combinational always block) 
	// is more convenient. Be careful not to create a latch.
	always@(*) begin
		case (state)
			A2: {fr3, fr2, fr1, dfr} = 4'b1111;
			B1: {fr3, fr2, fr1, dfr} = 4'b0110;
			B2: {fr3, fr2, fr1, dfr} = 4'b0111;
			C1: {fr3, fr2, fr1, dfr} = 4'b0010;
			C2: {fr3, fr2, fr1, dfr} = 4'b0011;
			D1: {fr3, fr2, fr1, dfr} = 4'b0000;
			default: {fr3, fr2, fr1, dfr} = 'x;
		endcase
	end
	
endmodule
