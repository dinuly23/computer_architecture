`include "general_architecture/funct.vh"
`include "general_architecture/opcodes.vh"

module fsm_step2(reset, opcode, stall_from_step3,  rf_w, mux_rf_rn1_select, mux_rf_rn2_select, load_step2, reset_step2);
	input reset;
	input [5:0] opcode;
	input stall_from_step3;
	output reg rf_w, mux_rf_rn1_select, mux_rf_rn2_select;
  	output load_step2;
	output reset_step2;
	
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
	
	assign reset_step2 = (reset || stall_from_step3) ? 1 : 0;
	assign load_step2 = 1;
	
endmodule