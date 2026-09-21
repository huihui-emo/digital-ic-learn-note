module top_module(
    input clk,
    input areset,    // Freshly brainwashed Lemmings walk left.
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging ); 
	
    parameter WL=0,WR=1,FAL=2,FAR=3,DL=4,DR=5;
    reg [2:0] state,next;
    always@(*)begin
    next=state;
        case(state)
            WL: next=~ground?FAL:(dig?DL:(bump_left?WR:WL));
            WR: next=~ground?FAR:(dig?DR:(bump_right?WL:WR));
            FAL: next=ground?WL:FAL;
            FAR: next=ground?WR:FAR;
            DL:next=ground?DL:FAL;
            DR:next=ground?DR:FAR;
        endcase
    end
        
    always@(posedge clk or posedge areset)begin
        if(areset) state<=WL;
        else state<=next;
    end
    
    assign walk_left=(state==WL);
    assign walk_right=(state==WR);
    assign aaah=((state==FAR)||(state==FAL));
    assign digging=((state==DR)||(state==DL));

endmodule
