module carry_lookahead_adder (a, b, sum, overflow);
    input wire[15:0] a;
    input wire[15:0] b;
    output reg[15:0] sum;
    output reg overflow;
    reg[15:0] c;
    wire [15:0] p, q;
    assign p = a + b;
    assign g = a & b;
    reg [3:0] P,G;
    assign P[0] = (p[3] & p[2]) & (p[1] & p[0]);
    assign P[1] = (p[7] & p[6]) & (p[5] & p[4]);
    assign P[2] = (p[11] & p[10]) & (p[9] & p[8]);
    assign P[3] = (p[15] & p[14]) & (p[13] & p[12]);
    assign G[0] = ((g[3] | (g[2] & p[3])) | (g[1] & p[2] & p[3])) | ((g[0] & p[1]) & (p[2] & p[3]));
    assign G[1] = ((g[7] | (g[6] & p[7])) | (g[5] & p[6] & p[7])) | ((g[4] & p[5]) & (p[6] & p[7]));
    assign G[2] = ((g[11] | (g[10] & p[11])) | (g[9] & p[10] & p[11])) | ((g[8] & p[9]) & (p[10] & p[11]));
    assign G[3] = ((g[15] | (g[14] & p[15])) | (g[13] & p[14] & p[15])) | ((g[12] & p[13]) & (p[14] & p[15]));
    wire [3:0] in;
    assign in[0] = 0;
    assign in[1] = G[0];
    assign in[2] = G[1] | (G[0] & P[1]);
    assign in[3] = (G[2] | (G[1] & P[2])) | (G[0] & P[1] & P[2]);
    integer i, j;
    always @(*) begin
        overflow <= (in[3] & P[3]) | G[3];
        for (i = 0;i < 3; i = i + 1) begin
            j = (i + 1) * 4;
            c[j] <= in[i];
            c[j+1] <= g[j] | (p[j] & in[i]);
            c[j+2] <= g[j+1] | (g[j] & p[j+1]);
            c[j+3] <= ((g[j+2] | (g[j+1] & p[j+2])) | (g[j] & p[j+1] & p[j+2])) | ((in[i] & p[j]) & (p[j+1] & p[j+2]));
        end
        sum <= a ^ b ^ c;
    end 
endmodule