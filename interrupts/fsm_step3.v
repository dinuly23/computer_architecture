`include "general_architecture/funct.vh"
`include "general_architecture/opcodes.vh"

module fsm_step3(reset, alu_zero, opcode, funct, alu_op, ext_imm_sign, 
				 mux_pc_branch_select, stall, load_step3, cause_step4, cause_step3, cause_step2,  overflow, carry, reset_step3, interrupts_signal, interrupts_addr);
	input alu_zero, reset; //
	input interrupts_signal;
	input [5:0] opcode; //
	input [3:0] funct; //
	input overflow, carry;
	
	
	output reg  ext_imm_sign;
	output reg [3:0] alu_op;
	output reg [1:0] mux_pc_branch_select;
	output reg stall;
	output load_step3;
	
	
	input [2:0] cause_step2;
	input [2:0] cause_step4;
	output reg [2:0] cause_step3;
	output reset_step3;
	output reg [15:0] interrupts_addr;
	
	
	always @(*)
	begin
		alu_op = 0;
		if(opcode == `EMPTY || opcode == `SYSCALL || `INTERRUPTS_ADDR) alu_op = `FUNCT_ADD;
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
		if(interrupts_signal) mux_pc_branch_select = 3;
	end
	
	always @(*)
	begin
		//000 - внешнее прерывание
		//001 - неверная команда
		//010 - перполнение алу
		//011 - systemcall
		//100 - нет препываний
		case(cause_step4)	
			3'b000: interrupts_addr = (interrupts_signal) ? 16'd0 : 16'd5;
			3'b001: interrupts_addr = (interrupts_signal) ? 16'd2 : 16'd5;
			3'b010: interrupts_addr = (interrupts_signal) ? 16'd2 : 16'd5;
			3'b011: interrupts_addr = (interrupts_signal) ? 16'd0 : 16'd5;
			3'b000: interrupts_addr = 16'd5; 
			default: interrupts_addr = 16'd5;
		endcase 
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
	
	always @(*)
	begin
		if(cause_step2 == 3'b100)
		case(opcode)
			`OPCODE_AR: cause_step3 = (((alu_op == `FUNCT_ADD) || (alu_op == `FUNCT_SUB)) &&  (carry == 1) )  ? 3'b010 : 3'b100;
		    `OPCODE_ADDIU: cause_step3 = (carry == 1) ? 3'b010 : 3'b100;
			`OPCODE_ADDI: cause_step3 = (overflow == 1) ? 3'b010 : 3'b100;
			`OPCODE_ANDIU: cause_step3 = 3'b100;
			`OPCODE_ANDI: cause_step3 = 3'b100;
			`OPCODE_ORIU: cause_step3 = 3'b100;
			`OPCODE_ORI: cause_step3 = 3'b100;
			`OPCODE_SLTIU: cause_step3 = 3'b100;
			`OPCODE_SLTI: cause_step3 = 3'b100;
			`OPCODE_BEQ: cause_step3 = (carry == 1)  ? 3'b010 : 3'b100;
			`OPCODE_BNE: cause_step3 = (carry == 1)  ? 3'b010 : 3'b100;
			`OPCODE_LW: cause_step3 = (carry == 1)  ? 3'b010 : 3'b100;
		 	`OPCODE_SW: cause_step3 = (carry == 1)  ? 3'b010 : 3'b100;
		    `OPCODE_J: cause_step3 = 3'b100;
			`EMPTY: cause_step3 = 3'b100;
			`SYSCALL: cause_step3 = 3'b100;
			default: cause_step3 = 3'b100;			
		endcase  
		else cause_step3 = cause_step2; 
	end
	
	assign reset_step3 = (reset || interrupts_signal) ? 1 : 0;
	
endmodule