// This file contains library modules to be used in your design. 

`include "constants.h"
`timescale 1ns/1ps

// Small ALU. 
//     Inputs: inA, inB, op. 
//     Output: out, zero
// Operations: bitwise and (op = 0)
//             bitwise or  (op = 1)
//             addition (op = 2)
//             subtraction (op = 6)
//             slt  (op = 7)
//             nor (op = 12)


/*
provlhma sthn ylopoihsh me symnlhrwma
*/
module ALU (out, zero, inA, inB, op);
	parameter N = 32; // bits
	input [3 : 0] op;  // max op = 12	
	input [N-1 : 0] inA, inB; // sizeof data
	
	output [N-1 : 0] out; //operation result
	reg [N-1: 0] out;
	output zero;
	reg zero;
	
  	//wire X1, X2, X3;
 	always @(op, inA, inB) begin
 		case (op)
			4'b0000: out = inA & inB;   
			4'b0001: out = inA | inB;
			4'b0010: out = inA + inB;
 	        	//    {
 	        	//    xor   (s, inA, inB, Cin);
 	        	//    and   (X1, inA, inB);  
	        	//    and   (X2, inA, Cin);
			//    and	  (X3, inB. Cin);  
 	        	//    or    (out, X1, X2, X3 );
 	        	//    }
			4'b0110: out = inA - inB; // LA8OS AFTO!
			4'b0111: out = (inA < inB)? 1:0; 
			4'b1100: out = ~(inA | inB);

			default: out = 32'b0x;
		endcase
	        if (out == 0)
	     		zero = 1;
	 end	
endmodule

/*
	-Epeidh den ginetai ta pc kai pc_new na einai tautoxrona
	wire kai reg, ftiaxnw 2 modules gia to pc prin kai meta
	- Sto 1o, ekei opou to pcNext einai wire, kai to pcCurr ein reg
	- Sto 2o, meta dhladh thn pros8esh

*/
module PC_curr(clock, reset, pcNext, pcCurr);
	input clock;
    	input reset;
    	input [31:0] pcNext;
	output [31:0] pcCurr;

	wire [31:0] pcNext;
    	reg [31:0] pcCurr;

	always @(posedge clock, negedge reset)
		pcCurr = (reset == 1)? pcNext: 0 ;
endmodule
 

module  next_PC(clock, reset,pcCurr, pcNext);
	input clock;
    	input reset;
	input [31:0] pcCurr;
    	output [31:0] pcNext;
    	

	wire [31 : 0] pcCurr;
	reg [31:0] pcNext;

	always @(negedge clock, negedge reset)
		pcNext = (reset == 1)? pcCurr + 4 : 0 ;
endmodule
	 
		








// Memory (active 1024 words, from 10 address lsbs).
// Read : enable ren, address addr, data dout
// Write: enable wen, address addr, data din.
module Memory (ren, wen, addr, din, dout);
	input         ren, wen;
  	input  [31:0] addr, din;
  	output [31:0] dout;

  	reg [31:0] data[4095:0];
  	wire [31:0] dout;

  	always @(ren or wen)   // It does not correspond to hardware. Just for error detection
  	  if (ren & wen)
  	  	$display ("\nMemory ERROR (time %0d): ren and wen both active!\n", $time);

	always @(posedge ren or posedge wen) begin // It does not correspond to hardware. Just for error detection
        if (addr[31:10] != 0)
      		$display("Memory WARNING (time %0d): address msbs are not zero\n", $time);
	   end  

  	assign dout = ((wen==1'b0) && (ren==1'b1)) ? data[addr[9:0]] : 32'bx;  
  
  	always @(din or wen or ren or addr)
  	 begin
  	  if ((wen == 1'b1) && (ren==1'b0))
  	      data[addr[9:0]] = din;
  	 end

endmodule


// Register File. Read ports: address raA, data rdA
//                            address raB, data rdB
//                Write port: address wa, data wd, enable wen.
module RegFile (clock, reset, raA, raB, wa, wen, wd, rdA, rdB);
	parameter N = 32; // data bits
	parameter M = 5; // address bits
	integer i;

	input wen, clock, reset; // 1-bit SIGNALS
	input [M-1 : 0] raA, raB; // read addresses(0-31) - 5bits 
	input [M-1: 0] wa; // write address
  	input [N-1:0] wd; // 32bit writeData
 
	output [N-1:0] rdA, rdB;
	reg [N-1 : 0] rdA, rdB; 

	reg [N-1:0] regs_data [0 : N-1]; // 32 32-bit regs
	/*
	-ka8e fora pou to reset einai miden, to kyklwma epistrefei sthn
	arxikh katastash
	-Arxikopoihsh kataxwrhtwn
	*/
	always @(reset)  begin
		if (reset == 0)  begin//if (reset gets off)
			for (i = 0; i < N; i = i + 1)  
				regs_data[i] = 0;
		end
	end
				

  	/*
 	 epilogh kataxwrhth gia anagnwsh(raA, raB)
 	 KAI 
 	 ana8esh timwn
 	 */   
	 
 	 always @(raA, raB)  begin
 	 	rdA = regs_data[raA];
         	rdB = regs_data[raB];
   	 end 
     
  	/*
  	-edw kanw thn eggrafh gia arnhtikh
  	akmh tou rologiou
	-kata thn eggrafh dn prepei to reset na 
	einai 1
 	*/
	always @(negedge clock) begin
		if ( wen == 1'b1 && reset == 1'b1 ) 
      			regs_data[wa] = wd;
	end


endmodule
