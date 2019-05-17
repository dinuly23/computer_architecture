module cpu_step1(clock, reset, pc_load, mux_pc_branch_select, pc_next_value1, pc_branch_value, ext_addr, im_instr, pc_next_value);
	input clock, reset;
	input pc_load; //from fsm
	input [1:0] mux_pc_branch_select;
	input [15:0] pc_next_value1;
	input [15:0] pc_branch_value;
	input [15:0] ext_addr;

	output [15:0] im_instr;
	output [15:0] pc_next_value;
	// == im, rst, mux ==
	
	
	// == счётчик команд ==
	wire [15:0] pc_value;
	wire [15:0] pc_new_value;
	//pc_load
	register_sload_sreset #(.W(16), .DV(0)) _program_counter(
		.i(pc_new_value),
		.l(pc_load),
		.clk(clock),
		.rst(reset),
		.o(pc_value)
	);
	// == память инструкций ==
  	instruction_memory _instruction_memory(
    		.addr(pc_value),
    		.instr(im_instr)
  	);
	
	// == +1 к значению счётчика команд ==
	assign pc_next_value = pc_value + 1;
	
	// == мультиплексор: ветвление счётчика команд ==
	mux #(.DW(16), .CW(2)) _mux_pc_branch(
		.i({pc_next_value1, pc_branch_value, ext_addr, 16'd0}),
		.s(mux_pc_branch_select),
		.o(pc_new_value)
	);
	 
endmodule
