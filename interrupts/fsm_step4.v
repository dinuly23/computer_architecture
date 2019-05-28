`include "general_architecture/funct.vh"
`include "general_architecture/opcodes.vh"

module fsm_step4(irq, opcode, dm_w, load_step4, cause_step4, cause_step3, interrupts_signal, reset_step4);
	input reset, irq;
	input interrupts_signal;
	input [5:0] opcode; 
	
	output reg dm_w;
	output load_step4;
	
	input [2:0] cause_step3;
	output reg [2:0] cause_step4; 
	output reset_step4;
	
	always @(*)
	begin
		dm_w = 0;
		if(opcode == `OPCODE_SW) dm_w = 1;
		if(opcode == `EMPTY || opcode == `SYSCALL || `INTERRUPTS_ADDR) dm_w = 0;
	end
	
	assign load_step4 = 1;
	
	always @(*)
	begin
		if(irq) cause_step4 = 3'b000; 
		else cause_step4 = cause_step3; 
	end
	
	assign reset_step4 = (reset || interrupts_signal) ? 1 : 0;
	
endmodule