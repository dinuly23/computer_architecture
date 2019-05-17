`include "general_architecture/funct.vh"
`include "general_architecture/opcodes.vh"

module fsm_step5(opcode, mux_rf_wd_select);
	
	input [5:0] opcode;
	output reg mux_rf_wd_select;
	
	always @(*)
	begin
		mux_rf_wd_select = 0;
		if(opcode == `OPCODE_LW) mux_rf_wd_select = 1;
	end

endmodule