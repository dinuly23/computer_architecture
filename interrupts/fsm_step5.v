`include "general_architecture/funct.vh"
`include "general_architecture/opcodes.vh"

module fsm_step5(reset, opcode, mux_rf_wd_select, cause_step4, epc_addr_step4, epc_addr, interrupts_signal);
	input reset;
	input [2:0] cause_step4;
	input [5:0] opcode;
	input [15:0] epc_addr_step4, epc_addr_step3, epc_addr;
	
	output reg mux_rf_wd_select;
	output interrupts_signal;
	
	always @(*)
	begin
		mux_rf_wd_select = 0;
		if(opcode == `OPCODE_LW) mux_rf_wd_select = 1;
	end

	assign interrupts_signal = (((cause_step4 != 3'b100) && (epc_addr_step4 >= 16'd5 ) && (epc_addr != epc_addr_step4)) 
								|| ((cause_step4 == 3'b000) && (epc_addr_step4 >= 16'd5 ) ) ) ? 1: 0; 
	
	
endmodule