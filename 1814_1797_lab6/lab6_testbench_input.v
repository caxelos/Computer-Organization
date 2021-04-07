
// Define top-level testbench
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Top level has no inputs or outputs
// It only needs to instantiate CPU, Drive the inputs to CPU (clock, reset)
// and monitor the outputs. This is what all testbenches do

`include "constants.h"    // Header file with opcodes
`timescale 1ns/1ps

module cpu_tb;
	parameter N = 32;
	parameter CLOCK_PERIOD = 2;

	integer   i;
	reg       clock, reset;    // Clock and reset signals
	reg [4:0] raA, raB, wa;
	reg wen, ren;
	reg [N-1:0] wd;
	wire [N-1:0] rdA, rdB;

	reg [N-1:0] data [31:0];    
	reg [N-1:0] pcCurr;	

// Instantiate CPU here with name cpu0
	CPU cpu0 (clock, reset);

// Initialization and signal generation
	initial begin
		assign ren = 1; // arxikopoiw to ren monima se 1
		assign pcCurr = 0;
	end
	
//Generate clock and reset signal here	
	initial begin
		clock = 1'b0;
		reset = 1'b0;

	
		// Initialize the module  
		# (4.25* CLOCK_PERIOD) reset = 1'b1;

	        // Initialize Register File with initial values. 
  		// cpu0 is the name of the cpu instance
  		// cpu_regs is the name of the register file instance in the CPU verilog file 
  		// data[] is the register file array
  
   		// Now apply some inputs
   		raA = 32'h1; raB = 32'h13; 
		# (2 * CLOCK_PERIOD)   
		raA = 32'hA;
		raB = 32'h1F; 
		# (2 * CLOCK_PERIOD)   
		wa = 32'h0A; 
  		wd = 32'hAA; 
  		wen = 1'b1; 
	end

	always
		# (CLOCK_PERIOD / 2) clock = ~clock;


 
	initial	begin  
		for (i = 0; i < 32; i = i+1)
	        	cpu0.cpu_regs.data[i] = i;   // Note that R0 = 0 in MIPS 
	       

 
    	$readmemh("program.hex", cpu0.cpu_IMem.data);
    	$display("data are: ");
    	for (i = 0; i < 5; i = i + 1)
  		$display("line %d, data %h\n", i, data[i]);

  // Edw, to "program.hex" einai ena arxeio pou prepei na brisketai sto 
  // directory pou trexete th Verilog kai na einai ths morfhs:
  
  // @0    00000000
  // @4    20100009
  // @8    00000000
  // @C    00000000
  // ...
  
  // H aristerh sthlh, meta to @, exei th dieythynsh ths mnhmhs (hex),
  // kai h deksia sthlh ta dedomena sth dieythynsh ayth (pali hex).
  // Sto paradeigma pio panw, oi lekseis stis dieythynseis 0, 8 kai 12
  // einai 0, kai sth dieythynsh 4 exei thn timh 32'h20100009. An o PC
  // diabasei thn dieythynsh 4, h timh ekei exei thn entolh
  //   addi $16 <- $0 + 9

  // To deytero orisma ths $readmemh einai pou akribws brisketai h mnhmh
  // pou tha arxikopoihthei. Sto paradeigma, to "dat0" einai to onoma pou
  // dwsame sto instance tou datapath. To "mem" einai to onoma pou exei
  // to instance ths mnhmhs MESA sto datapath, kai to "data" einai to 
  // onoma pou exei to pragmatiko array ths mhnhs mesa sto module ths.
  // An exete dwsei diaforetika onomata, allakste thn $readmemh.

  // Enallaktika, an sas boleyei perissotero, yparxei h entolh $readmemb
  // me thn akribws idia syntaksh. H aristerh sthlh tou arxeiou exei
  // thn idia morfh (dieythynseis se hex), alla h deksia sthlh exei
  // ta dedomena sto dyadiko. Etsi h add mporouse na einai:

  // @4    00100000000100000000000000001001

  // ... h kai akoma kalytera:
  
  // @4    001000_00000_10000_0000000000001001

  // (h Verilog epitrepei diaxwristika underscores).


  // Termatismos ekteleshs:
	$finish;

	end  // initial 

endmodule