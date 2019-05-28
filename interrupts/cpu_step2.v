module cpu_step2(clock, reset, rf_w, rf_wd, im_instr, mux_rf_rn1_select, mux_rf_rn2_select, dest, rf_rd1, rf_rd2);
	input clock, reset;
	input rf_w; //from fsm
	input [15:0] rf_wd; //from step5
	input [15:0] im_instr;
	input mux_rf_rn1_select, mux_rf_rn2_select; //from fsm
	input [1:0] dest;
	output [15:0] rf_rd1, rf_rd2; 
	// == mux_rf1, mux_rf1, rf ==

	// == куски инструкции ==
	//wire [5:0] instr_opcode = im_instr[15:10]; //код операции
	//wire [3:0] instr_funct = im_instr[3:0];  //код операции alu
	wire [1:0] instr_n1 = im_instr[9:8];
	wire [1:0] instr_n2 = im_instr[7:6];
	wire [1:0] instr_n3 = im_instr[5:4];
	//wire [5:0] instr_imm = im_instr[5:0];
	//wire [9:0] instr_addr = im_instr[9:0];
	
	
	// == блок регистров ==
	wire [1:0] rf_rn1, rf_rn2;
	register_file _register_file(
		.rn1(rf_rn1),
		.rn2(rf_rn2),
		.wn(dest),			//dest нужно протянуть с последнего step-а
		.w(rf_w),
		.rst(reset),
		.clk(clock),
		.wd(rf_wd),
		.rd1(rf_rd1),
		.rd2(rf_rd2)
	);

	// == мультиплексор: первый номер считываемого регистра ==
	mux #(.DW(2), .CW(1)) _mux_rf_rn1(
		.i({instr_n1, instr_n2}),
		.s(mux_rf_rn1_select),
		.o(rf_rn1)
	);
	// == мультиплексор: второй номер считываемого регистра ==
	mux #(.DW(2), .CW(1)) _mux_rf_rn2(
		.i({instr_n2, instr_n3}),
		.s(mux_rf_rn2_select),
		.o(rf_rn2)
	);


endmodule
