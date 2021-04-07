`include "constants.h"

//module dataPath_controlUnit(Op_num, ALU_control, writeReg, Function);
 module dataPath_controlUnit();
	parameter N = 32;
	
	wire [3 : 0] ALU_op; //

	wire reset, clock; //signals
	wire [N-1 : 0] pcNext, pcCurr;
	wire ren;
	wire wen;

	wire [N-1 : 0] din, dout ;

	wire [N-1 : 0] rdA; // module ALU
	wire [N-1 : 0] rdB;
	wire zero;
	wire [N-1 : 0] out;

	/*
	- Arxika, me vash to sxhma sthn ekfwnhsh, ekteloume thn diadikasia tou PC
		-AN
	- Epeita ekteloume ton kwdika gia ton instruction memory
	- meta pairnoume apo to arxeio kataxwrhtwn ta dedomena rd1, rd2 gia
	na ektelestoun sthn ALU oi arithmhtikes pra3eis
	- Kaloume thn ALU gia thn ektelesh ths sygkekrimenhs pra3hs
	- h e3odos(out) ths ALU ginetai eisodos tou RegFile gia eggrafh(out <- wd)

	- exw orisei gia to dout(H EKSODOS TOU INSTRUCTION MEMORY)
	(0 - 5) opNum, (6, 10) shamt, (11 - 15) rdA, (16 - 20)  rdB,
	(21 - 25) 	
	*/	
	
	PC_curr PC_curr0(clock, reset, pcNext, pcCurr);

	next_PC next_PC0(clock, reset, pcCurr, pcNext);
	
	Memory  Memory_0(ren, wen, pcCurr, din, dout); // opou dout mia 32-bit entolh mips
	
	// h e3odos tou memory einai eisodos tou RegFile
	RegFile  RegFile_0(clock, reset, dout[25:21], dout[20:16], dout[15:11], wen, out, rdA, rdB);
	
	ALU  ALU_0(out, Zero, rdA, rdB, ALU_op); 

endmodule
