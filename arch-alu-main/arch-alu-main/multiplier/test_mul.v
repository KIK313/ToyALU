`include "mul.v"
module test_adder;
    wire [15:0] answer;
    reg [15:0] a, b;
    reg [15:0] res;
    multiplier mm(a, b, answer);
    integer i;
    initial begin 
        for(i=1;i<=100;i=i+1) begin
            a[15:0] = $random;
            b[15:0] = $random;
            res = a * b;
            #1;
            $display("TEST CASE %d: %d * %d = %d",i, a, b, answer);
            if (answer !== res[15:0]) begin
                $display("Wrong Answer");
            end
        end 
        $display("Ok");
        $finish;
    end
endmodule