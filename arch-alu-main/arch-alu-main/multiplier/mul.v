module adder (a, b, sum);
    input wire[15:0] a;
    input wire[15:0] b;
    output reg[15:0] sum;
    reg[15:0] c;
    wire [15:0] p, g;
    assign p = a | b;
    assign g = a & b;
    wire [3:0] P,G;
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
        for (i = 0;i < 4; i = i + 1) begin
            j = i * 4;
            c[j] <= in[i];
            c[j+1] <= g[j] | (p[j] & in[i]);
            c[j+2] <= (g[j+1] | (g[j] & p[j+1])) | (in[i] & p[j] & p[j+1]);
            c[j+3] <= ((g[j+2] | (g[j+1] & p[j+2])) | (g[j] & p[j+1] & p[j+2])) | ((in[i] & p[j]) & (p[j+1] & p[j+2]));
        end
        sum = a ^ b ^ c;
    end 
endmodule
module half_adder(a, b, c, s1, s2);
    input wire[15:0] a;
    input wire[15:0] b;
    input wire[15:0] c;
    output wire[15:0] s1;
    output wire[15:0] s2;
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin
            assign s1[i] = a[i] ^ b[i] ^ c[i];
        end
        assign s2[0] = a[0] & (~a[0]);
        for (i = 0; i < 15; i = i + 1) begin
            assign s2[i+1] = (a[i] & b[i]) | (a[i] & c[i]) | (b[i] & c[i]);
        end
    endgenerate
endmodule
module multiplier(a, b, pro);
    input wire[15:0] a;
    input wire[15:0] b;
    wire[15:0] a0, a1, a2, a3;
    wire[15:0] p[7:0];
    wire[15:0] st1[3:0];
    wire[15:0] st2[3:0];
    wire[15:0] st3[1:0];
    wire[15:0] st4[1:0];
    output wire[15:0] pro;
    adder ADD(a1, a2, a3);
    genvar i, j;
    generate
        for (i = 0; i < 16; i = i + 1) begin 
            assign a1[i] = a[i];
        end
        for (i = 0; i < 15; i = i + 1) begin
            assign a2[i+1] = a[i];
        end
        assign a2[0] = a[0] & (~a[0]);
        for (i = 0; i < 16; i = i + 1) begin
            assign a0[i] = a[i] & (~a[i]); 
        end
        for (i = 0; i < 16; i = i + 2) begin 
            for (j = 0; j < i; j = j + 1) begin
                assign p[i/2][j] = a0[j]; 
            end
            for (j = 0; j < 16; j = j + 1) begin
                if (i + j < 16) begin
                    assign p[i/2][i+j] = (a0[j] & (~b[i]) & (~b[i+1])) | (a1[j] & b[i] & (~b[i+1])) | 
                        (a2[j] & b[i+1] & (~b[i])) | (a3[j] & b[i+1] & b[i]); 
                end
            end 
        end
    endgenerate        
    half_adder hd1 (p[0], p[1], p[2], st1[0], st1[1]);
    half_adder hd2 (p[3], p[4], p[5], st1[2], st1[3]);
    half_adder hd3 (st1[0], st1[1], st1[2], st2[0], st2[1]);
    half_adder hd4 (st1[3], p[6], p[7], st2[2], st2[3]);
    half_adder hd5 (st2[0], st2[1], st2[2], st3[0], st3[1]);
    half_adder hd6 (st3[0], st3[1], st2[3], st4[0], st4[1]);
    adder GET(st4[0], st4[1], pro);
endmodule
