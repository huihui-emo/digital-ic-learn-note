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
    reg[2:0] state,next;
    reg [4:0] count;
    parameter WL=0,WR=1,FAL=2,FAR=3,DL=4,DR=5,SPLAT=6;
    always@(posedge clk or posedge areset)begin
        if(areset) begin
            state<=WL;
            count<=0;
        end
        else begin state<=next;
            if(next==FAL||next==FAR) begin
                if(~ground)begin
                    if(count<31) count<=count+1;
                end
                else count<=0;
            end
            else count<=0;
        end
    end
    
    always@(*)begin
        next=state;
        case(state)
            WL: next=~ground?FAL:(dig?DL:(bump_left?WR:WL));
            WR: next=~ground?FAR:(dig?DR:(bump_right?WL:WR));
            FAL: next=ground?((count>20)?SPLAT:WL):FAL;
            FAR: next=ground?((count>20)?SPLAT:WR):FAR;
            DL: next=~ground?FAL:DL;
            DR: next=~ground?FAR:DR;
            SPLAT: next=SPLAT;
            default: next=WL;
        endcase
    end
    
    assign walk_left=(state==WL);
    assign walk_right=(state==WR);
    assign aaah=(state==FAL||state==FAR);
    assign digging=(state==DL||state==DR);
                
        
        
endmodule
