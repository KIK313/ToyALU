module Add (a, b, sum);
    input wire[31:0] a;
    input wire[31:0] b;
    output reg[31:0] sum;
    reg[31:0] c;
    wire [31:0] p, g;
    assign p = a | b;
    assign g = a & b;
    wire [7:0] P,G;
    assign P[0] = (p[3] & p[2]) & (p[1] & p[0]);
    assign P[1] = (p[7] & p[6]) & (p[5] & p[4]);
    assign P[2] = (p[11] & p[10]) & (p[9] & p[8]);
    assign P[3] = (p[15] & p[14]) & (p[13] & p[12]);
    assign P[4] = (p[19] & p[18]) & (p[17] & p[16]);
    assign P[5] = (p[23] & p[22]) & (p[21] & p[20]);
    assign P[6] = (p[27] & p[26]) & (p[25] & p[24]);
    assign P[7] = (p[31] & p[30]) & (p[29] & p[28]);

    assign G[0] = ((g[3] | (g[2] & p[3])) | (g[1] & p[2] & p[3])) | ((g[0] & p[1]) & (p[2] & p[3]));
    assign G[1] = ((g[7] | (g[6] & p[7])) | (g[5] & p[6] & p[7])) | ((g[4] & p[5]) & (p[6] & p[7]));
    assign G[2] = ((g[11] | (g[10] & p[11])) | (g[9] & p[10] & p[11])) | ((g[8] & p[9]) & (p[10] & p[11]));
    assign G[3] = ((g[15] | (g[14] & p[15])) | (g[13] & p[14] & p[15])) | ((g[12] & p[13]) & (p[14] & p[15]));
    assign G[4] = ((g[19] | (g[18] & p[19])) | (g[17] & p[18] & p[19])) | ((g[16] & p[17]) & (p[18] & p[19]));
    assign G[5] = ((g[23] | (g[22] & p[23])) | (g[21] & p[22] & p[23])) | ((g[20] & p[21]) & (p[22] & p[23]));    
    assign G[6] = ((g[27] | (g[26] & p[27])) | (g[25] & p[26] & p[27])) | ((g[24] & p[25]) & (p[26] & p[40]));
    assign G[7] = ((g[31] | (g[30] & p[31])) | (g[29] & p[30] & p[31])) | ((g[28] & p[29]) & (p[30] & p[31])); 
    wire [7:0] in;
    assign in[0] = 0;
    assign in[1] = G[0];
    assign in[2] = G[1] | (G[0] & P[1]);
    assign in[3] = (G[2] | (G[1] & P[2])) | (G[0] & P[1] & P[2]);
    assign in[4] = ((G[3] | (G[2] & P[3])) | (G[1] & P[2] & P[3])) | (G[0] & P[1] & P[2] & P[3]);
    assign in[5] = G[4] | (in[4] & P[4]);
    assign in[6] = (G[5] | (G[4] & P[5])) | (in[4] & (P[4] & p[5]));
    assign in[7] = ((G[6] | (G[5] & P[6])) | (G[4] & P[5] & P[6])) | (in[4] & (P[4]&P[5]&P[6]));
    integer i, j;
    always @(*) begin
        for (i = 0;i < 8; i = i + 1) begin
            j = i * 4;
            c[j] <= in[i];
            c[j+1] <= g[j] | (p[j] & in[i]);
            c[j+2] <= (g[j+1] | (g[j] & p[j+1])) | (in[i] & p[j] & p[j+1]);
            c[j+3] <= ((g[j+2] | (g[j+1] & p[j+2])) | (g[j] & p[j+1] & p[j+2])) | ((in[i] & p[j]) & (p[j+1] & p[j+2]));
        end
        sum = a ^ b ^ c;
    end 
endmodule