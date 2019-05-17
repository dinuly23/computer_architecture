`include "general_architecture/funct.vh"
`include "general_architecture/opcodes.vh"

module fsm_step3(alu_zero, opcode, funct, alu_op, ext_imm_sign, 
				 mux_pc_branch_select, stall, load_step3);
	input alu_zero; //
	input [5:0] opcode; //
	input [3:0] funct; //
	output reg  ext_imm_sign;
	output reg [3:0] alu_op;
	output reg [1:0] mux_pc_branch_select;
	output reg stall;
	output load_step3;
	
	always @(*)
	begin
		alu_op = 0;
		if(opcode == `EMPTY) alu_op = `FUNCT_ADD;
		if(opcode == `OPCODE_AR) alu_op = funct;
		if(opcode == `OPCODE_ADDIU ||
		   opcode == `OPCODE_ADDI ||
		   opcode == `OPCODE_LW ||
		   opcode == `OPCODE_SW) alu_op = `FUNCT_ADD;
		if(opcode == `OPCODE_ANDIU ||
		   opcode == `OPCODE_ANDI) alu_op = `FUNCT_AND;
		if(opcode == `OPCODE_ORIU ||
		   opcode == `OPCODE_ORI) alu_op = `FUNCT_OR;
		if(opcode == `OPCODE_SLTIU) alu_op = `FUNCT_SLTU;
		if(opcode == `OPCODE_SLTI) alu_op = `FUNCT_SLT;
		if(opcode == `OPCODE_BEQ ||
		   opcode == `OPCODE_BNE) alu_op = `FUNCT_SUB;
	end
  
	always @(*)
	begin
		ext_imm_sign = 1;
		if(opcode == `OPCODE_ADDIU ||
		   opcode == `OPCODE_ANDIU ||
		   opcode == `OPCODE_ORIU ||
		   opcode == `OPCODE_SLTIU) ext_imm_sign = 0;
	end

	always @(*)
	begin
		mux_pc_branch_select = 0;
		if(opcode == `OPCODE_BEQ && alu_zero == 1) mux_pc_branch_select = 1;
		if(opcode == `OPCODE_BNE && alu_zero == 0) mux_pc_branch_select = 1;
		if(opcode == `OPCODE_J) mux_pc_branch_select = 2;
	end
	
	always @(*)
	begin
		stall = 0;
		if ((opcode == `OPCODE_BEQ && alu_zero == 1) || 
			(opcode == `OPCODE_BNE && alu_zero == 0) ||
		   	(opcode == `OPCODE_J)) //был if или jump 
			stall = 1; 
	end
	
    assign load_step3 =1;
endmodule