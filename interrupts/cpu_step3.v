module cpu_step3(clock, reset, alu_op, mux_alu_in1_select, mux_alu_in2_select, ext_imm_sign, rf_rd1, rf_rd2, 
			bypass_from_alu, bypass_from_dm, instr_imm, instr_addr, pc_next_value, ext_addr, pc_branch_value, alu_zero, alu_out,
			carry, overflow);
	input clock, reset;
	input [3:0] alu_op; //from fsm
	input [1:0] mux_alu_in1_select, mux_alu_in2_select; //from fsm
	input ext_imm_sign; //сигнал расширения константы
	input [15:0] rf_rd1, rf_rd2, bypass_from_alu, bypass_from_dm;	

	input [5:0] instr_imm;
	input [9:0] instr_addr;
	input [15:0] pc_next_value; 

	output [15:0] ext_addr;
	output [15:0] pc_branch_value;
	output alu_zero;
	output [15:0] alu_out;
	output carry, overflow;
	// == alu, mux_alu1, mux_alu2, mux_pc ==
	
	// == алу ==
	wire [15:0] alu_in1, alu_in2;
	alu _alu(
		.in1(alu_in1),
		.in2(alu_in2),
		.op(alu_op),
		.out(alu_out),
		.zero(alu_zero),
		.carry(carry),
		.overflow(overflow)
	);
		
	// == расширитель константы imm инструкции ==
	wire [15:0] ext_imm =  
		ext_imm_sign
		? {{10{instr_imm[5]}}, instr_imm}
		: {10'd0, instr_imm};
	
	// == расширитель константы addr инструкции ==
	assign ext_addr = {6'd0, instr_addr}; 
	// == сложение счётчика команд с константой при условном ветвлении
	assign pc_branch_value = pc_next_value + ext_imm + 16'd5; //+5 конец обработчика прерываний
  

	// == мультиплексор: первый вход алу ==
	mux #(.DW(16), .CW(2)) _mux_alu_in1(
		.i({rf_rd1, rf_rd2, bypass_from_alu, bypass_from_dm}),
		.s(mux_alu_in1_select),
		.o(alu_in1)
	);
	// == мультиплексор: второй вход алу ==
	mux #(.DW(16), .CW(2)) _mux_alu_in2(
		.i({rf_rd2, ext_imm, bypass_from_alu, bypass_from_dm}),
		.s(mux_alu_in2_select),
		.o(alu_in2)
	);
	

endmodule
