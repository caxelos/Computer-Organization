`include "constants.h"

/************** Main FSM in ID pipe stage  *************/
module fsm_main(output reg RegDst,
                output reg Branch,  
                output reg MemRead,
                output reg MemWrite,  
                output reg MemToReg,  
                output reg ALUSrc,  
                output reg RegWrite,  
                output reg [1:0] ALUcntrl,  
                input [5:0] opcode);

  always @(*) 
   begin
     case (opcode)
      6'b100_000: 
          begin 
            RegDst = 1'b1;
            MemRead = 1'b0;
            MemWrite = 1'b0;
            MemToReg = 1'b0;
            ALUSrc = 1'b0;
            RegWrite = 1'b1;
            Branch = 1'b0;         
            ALUcntrl  = 2'b10; // R             
          end
       6'b100_011:   
           begin 
            RegDst = 1'b0;
            MemRead = 1'b1;
            MemWrite = 1'b0;
            MemToReg = 1'b1;
            ALUSrc = 1'b1;
            RegWrite = 1'b1;
            Branch = 1'b0;
            ALUcntrl  = 2'b00; // add
           end
        6'b101011:   
           begin 
            RegDst = 1'b0;
            MemRead = 1'b0;
            MemWrite = 1'b1;
            MemToReg = 1'b0;
            ALUSrc = 1'b1;
            RegWrite = 1'b0;
            Branch = 1'b0;
            ALUcntrl  = 2'b00; // add
           end
       6'b000_100:  
           begin 
            RegDst = 1'b0;
            MemRead = 1'b0;
            MemWrite = 1'b0;
            MemToReg = 1'b0;
            ALUSrc = 1'b0;
            RegWrite = 1'b0;
            Branch = 1'b1;
            ALUcntrl = 2'b01; // sub
           end
       default:
           begin
            RegDst = 1'b0;
            MemRead = 1'b0;
            MemWrite = 1'b0;
            MemToReg = 1'b0;
            ALUSrc = 1'b0;
            RegWrite = 1'b0;
            ALUcntrl = 2'b00; 
         end
      endcase
    end // always
endmodule


/**************** Module for Bypass Detection in EX pipe stage goes here  *********/
 module  fsm_bypass_ex(output reg [1:0] bypassA,
                       output reg [1:0] bypassB, 
                       input [4:0] idex_rs,
                       input [4:0] idex_rt,
                       input [4:0] exmem_rd, 
                       input [4:0] memwb_rd, 
                       input       exmem_regwrite, 
                       input       memwb_regwrite); 

	/************* E3ISWSEIS EX/MEM ********************/
	always@ (exmem_regwrite, idex_rs, exmem_regwrite, exmem_rd  )   begin
		if (  (exmem_regwrite == 1) && (exmem_rd != 0) &&
		   (exmem_rd == idex_rs) ) begin
			
			bypassA = 2;
		end
	
	end

	always @(memwb_regwrite, idex_rt, exmem_regwrite, memwb_rd) begin
		if (  (exmem_regwrite == 1) && (exmem_rd != 0) &&
		   (exmem_rd == idex_rt) ) begin
			
			bypassB = 2;
		end
	end	
		

	/************* E3ISWSEIS MEM/WB ********************/
	always@ (memwb_regwrite, idex_rs, exmem_regwrite, memwb_rd  )   begin
		if (  (memwb_regwrite == 1) && (memwb_rd != 0) && (memwb_rd == idex_rs) ) begin
			if ( (exmem_regwrite != idex_rs)  ||  (exmem_regwrite == 0) )    
				bypassA <= 1;
		end
	end

			 
	always@ (memwb_regwrite, idex_rt, exmem_regwrite,  memwb_rd  )   begin
		if (memwb_regwrite == 1 &&  memwb_rd != 0 &&  memwb_rd == idex_rt) begin
			if ( (exmem_regwrite != idex_rt)  ||  (exmem_regwrite == 0))    
				bypassB <= 1;
		end
	end	
	/*****************************************************/
	
endmodule          
                       

/**************** Module for Stall Detection in ID pipe stage goes here  *********/
module stall_generator (output reg idex_delay, // outputs
		        output reg PCWrite,
		        output reg ifid_Write,
		        input [4:0] ifid_instr_rs,  // inputs
		        input [4:0] ifid_instr_rt,		
		        input [4:0] idex_instr_rt,
		        input idex_MemRead
		       );
	
	always @(ifid_Write, ifid_instr_rs, ifid_instr_rt, idex_instr_rt, idex_MemRead) begin
		if (idex_MemRead == 1 &&
		 ( idex_instr_rt == ifid_instr_rs || idex_instr_rt == ifid_instr_rt) )  begin
			PCWrite <= 0;
			idex_delay <= 1;
			ifid_Write <= 0;
		end
		else begin
			PCWrite <= 1;
			idex_delay <= 0;
			ifid_Write <= 1;
		end
	end
endmodule			

            
                       
/************** FSM for ALU control in EX pipe stage  *************/
module fsm_alu(output reg [3:0] ALUOp,                  
               input [1:0] ALUcntrl,
               input [5:0] func);

  always @(ALUcntrl or func)  
    begin
      case (ALUcntrl)
        2'b10: 
           begin
             case (func)
              6'b100000: ALUOp  = 4'b0010; // add
              6'b100010: ALUOp = 4'b0110; // sub
              6'b100100: ALUOp = 4'b0000; // and
              6'b100101: ALUOp = 4'b0001; // or
              6'b100111: ALUOp = 4'b1100; // nor
              6'b101010: ALUOp = 4'b0111; // slt
              default: ALUOp = 4'b0000;       
             endcase 
          end   
        2'b00: 
              ALUOp  = 4'b0010; // add
        2'b01: 
              ALUOp = 4'b0110; // sub
        default:
              ALUOp = 4'b0000;
     endcase
    end
endmodule
