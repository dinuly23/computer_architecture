`include "general_architecture/funct.vh"
`include "general_architecture/opcodes.vh"

module fsm_step2(reset, opcode, stall_from_step3,  rf_w, mux_rf_rn1_select, mux_rf_rn2_select, load_step2, reset_step2, cause_step2, cause_step1, interrupts_signal, interrupts_j, interrupts_addr_add);
	input reset;
	input interrupts_signal;
	input [5:0] opcode;
	input stall_from_step3;
	
	output reg rf_w, mux_rf_rn1_select, mux_rf_rn2_select;
  	output load_step2;
	
	input [2:0] cause_step1;
	output reg [2:0] cause_step2;
	output reset_step2;
	output interrupts_j; //signal for mux step2
	output interrupts_addr_add; //signal if opcode == interrupts_addr
	
	always @(*)
	begin
		rf_w = 0;
		if(opcode == `OPCODE_AR ||
		   opcode == `OPCODE_ADDIU ||
		   opcode == `OPCODE_ADDI ||
		   opcode == `OPCODE_ANDIU ||
		   opcode == `OPCODE_ANDI ||
		   opcode == `OPCODE_ORIU ||
		   opcode == `OPCODE_ORI ||
		   opcode == `OPCODE_SLTIU ||
		   opcode == `OPCODE_SLTI ||
		   opcode == `OPCODE_LW
		  ) rf_w = 1;
	end
	
	always @(*)
	begin
		mux_rf_rn1_select = 1;
		mux_rf_rn2_select = 1;
		if(opcode == `OPCODE_BEQ ||
		   opcode == `OPCODE_BNE ||
		   opcode == `OPCODE_LW ||
		   opcode == `OPCODE_SW)
		begin
		  mux_rf_rn1_select = 0;
		  mux_rf_rn2_select = 0;
		end
	end
	
	assign reset_step2 = (reset || stall_from_step3 || interrupts_signal) ? 1 : 0;
	assign load_step2 = 1;
	
	always @(*)
	begin
		if(cause_step1 == 3'b100)
		case(opcode)
			`OPCODE_AR: cause_step2 = 3'b100;
			`OPCODE_ADDIU: cause_step2 = 3'b100;
			`OPCODE_ADDI: cause_step2 = 3'b100;
			`OPCODE_ANDIU: cause_step2 = 3'b100;
			`OPCODE_ANDI: cause_step2 = 3'b100;
			`OPCODE_ORIU: cause_step2 = 3'b100;
			`OPCODE_ORI: cause_step2 = 3'b100;
			`OPCODE_SLTIU: cause_step2 = 3'b100;
			`OPCODE_SLTI: cause_step2 = 3'b100;
			`OPCODE_BEQ: cause_step2 = 3'b100;
			`OPCODE_BNE: cause_step2 = 3'b100;
			`OPCODE_LW: cause_step2 = 3'b100;
			`OPCODE_SW: cause_step2 = 3'b100;
			`OPCODE_J: cause_step2 = 3'b100;
			`EMPTY: cause_step2 = 3'b100;
			`SYSCALL: cause_step2 = 3'b011;
			`INTERRUPTS_J: cause_step2 = 3'b100;
			`INTERRUPTS_ADDR: cause_step2 = 3'b100;
			default: cause_step2 = 3'b001; //incorrect opcode
		endcase
		else cause_step2 = cause_step1;
	end 
		
	assign interrupts_j = (opcode == `INTERRUPTS_J) ? 1 : 0; 
	assign interrupts_addr_add = (opcode == `INTERRUPTS_ADDR) ? 1 : 0;
	
endmodule