`include "general_architecture/funct.vh"
`include "general_architecture/opcodes.vh"

/*module fsm_step1(stall_from_step3, pc_load, load_step1, reset_step1, stop_load_pc, stop_load_reg, do_reset_reg);

	input stall_from_step3;
	output pc_load;
	output load_step1;
	output reset_step1;
	
	assign pc_load = stop_load_pc? 0 : 1;
	 
	assign reset_step1 = (do_reset_reg || stall_from_step3) ? 1 : 0;
	assign load_step1 = stop_load_reg? 0 : 1;
endmodule
*/
module fsm_step1(reset, stall_from_step3, pc_load, load_step1, reset_step1, load_hazard_signal, cause_step1, interrupts_signal);
	input reset;
	input interrupts_signal;
	input stall_from_step3;
	input load_hazard_signal;
	
	output pc_load;
	output load_step1;
	output reset_step1;
	output [2:0] cause_step1;
	
	assign pc_load = (load_hazard_signal) ? 0 : 1;
	 
	assign reset_step1 = (reset || stall_from_step3 || interrupts_signal) ? 1 : 0;
	assign load_step1 = (load_hazard_signal) ? 0 : 1;
	
	
	//000 - внешнее прерывание
	//001 - неверная команда
	//010 - перполнение алу
	//011 - systemcall
	//100 - нет препываний
	assign cause_step1 = 3'b100; 
	
endmodule