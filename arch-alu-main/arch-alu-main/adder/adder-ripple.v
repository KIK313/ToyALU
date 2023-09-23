/* ACM Class System (I) Fall Assignment 1 
 *
 *
 * Implement your naive adder here
 * 
 * GUIDE:
 *   1. Create a RTL project in Vivado
 *   2. Put this file into `Sources'
 *   3. Put `test_adder.v' into `Simulation Sources'
 *   4. Run Behavioral Simulation
 *   5. Make sure to run at least 100 steps during the simulation (usually 100ns)
 *   6. You can see the results in `Tcl console'
 *
 */

module adder(a, b, sum, overflow);
	input wire[15:0] a;
	input wire[15:0] b;
	output reg[15:0] sum;
	output reg overflow;
	wire[15:0] c;
	assign c[0] = 0;
	assign c[1] = a[0] & b[0];
	assign c[2] = (a[1] & b[1]) | (a[1] & c[1]) | (b[1] & c[1]);
	assign c[3] = (a[2] & b[2]) | (a[2] & c[2]) | (b[2] & c[2]);
	assign c[4] = (a[3] & b[3]) | (a[3] & c[3]) | (b[3] & c[3]);
	assign c[5] = (a[4] & b[4]) | (a[4] & c[4]) | (b[4] & c[4]);
	assign c[6] = (a[5] & b[5]) | (a[5] & c[5]) | (b[5] & c[5]);
	assign c[7] = (a[6] & b[6]) | (a[6] & c[6]) | (b[6] & c[6]);
	assign c[8] = (a[7] & b[7]) | (a[7] & c[7]) | (b[7] & c[7]);
	assign c[9] = (a[8] & b[8]) | (a[8] & c[8]) | (b[8] & c[8]);
	assign c[10] = (a[9] & b[9]) | (a[9] & c[9]) | (b[9] & c[9]);
	assign c[11] = (a[10] & b[10]) | (a[10] & c[10]) | (b[10] & c[10]);
	assign c[12] = (a[11] & b[11]) | (a[11] & c[11]) | (b[11] & c[11]);
	assign c[13] = (a[12] & b[12]) | (a[12] & c[12]) | (b[12] & c[12]);
	assign c[14] = (a[13] & b[13]) | (a[13] & c[13]) | (b[13] & c[13]);
	assign c[15] = (a[14] & b[14]) | (a[14] & c[14]) | (b[14] & c[14]);
	integer i;
	always @(*) begin
		overflow <= (a[15] & b[15]) | (a[15] & c[15]) | (b[15] & c[15]);
		for (i = 0; i < 16; i=i+1) begin
			sum[i] <= a[i] ^ b[i] ^ c[i];
		end
	end
	// TODO: Implement this module here
	
endmodule
