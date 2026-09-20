module top_module(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out); //

    parameter A=0, B=1, C=2, D=3;

    // State transition logic: Derive an equation for each state flip-flop.
    assign next_state[A] = ~in&(state[C]|state[A]);
    assign next_state[B] = in&(state[A]|state[B]|state[D]);
    assign next_state[C] = ~in&(state[B]|state[D]);
    assign next_state[D] = in&state[C];

    // Output logic: 
    assign out =state[D];

endmodule
//onehot编码，可以使用相对简单的数据流描述，前提是把每个位Q3Q2Q1Q0设出来，可以参考本题的方法，把对应的位设成0123这样我们在state里面调用就正好对应了字母本身的状态
//可以通过状态转移表直接写出表达式非常方便，缺点是增加了触发器的个数，原本四个状态我们用二进制编码只需要两个触发器，现在的话需要用四个触发器
//输出一开始写错了的原因还是我习惯于二进制那么去想了，其实给你独热码的好处就是经过化简我们可以用state里面的位数来代表他字母的状态，每一位对应一个状态所以不需要想太多直接根据状态转移表写出
//如果还有时序逻辑的话我写out=(state==4'b1000);应该是对的
