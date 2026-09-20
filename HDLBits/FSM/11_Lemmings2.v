module top_module(
    input clk,
    input areset,    // Freshly brainwashed Lemmings walk left.
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah ); 
parameter WL=0,WR=1,FAL=2,FAR=3;
    reg [1:0] state,next;
    always@(*)begin
    next=state;
        case(state)
            WL: next=~ground?FAL:(bump_left?WR:WL);
            WR: next=~ground?FAR:(bump_right?WL:WR);
            FAL: next=ground?WL:FAL;
            FAR: next=ground?WR:FAR;
        endcase
    end
        
    always@(posedge clk or posedge areset)begin
        if(areset) state<=WL;
        else state<=next;
    end
    
    assign walk_left=(state==WL);
    assign walk_right=(state==WR);
    assign aaah=((state==FAR)|(state==FAL));
    
endmodule
