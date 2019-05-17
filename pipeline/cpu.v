`include "general_architecture/funct.vh"
`include "general_architecture/opcodes.vh"

module cpu(clock, reset);
  input clock, reset;
 
  wire load_hazard_signal; // 0-ok , 1- hazard 
  //step1
  //pc_new_value
  wire [15:0] ext_addr, pc_branch_value;
  wire pc_load; //from fsm1 +
  wire [15:0] im_instr, pc_next_value;
  wire [1:0] mux_pc_branch_select; //from fsm3
  cpu_step1 _cpu_step1(.clock(clock), .reset(reset), .pc_load(pc_load), .mux_pc_branch_select(mux_pc_branch_select), .pc_next_value1(pc_next_value), 
                       .pc_branch_value(pc_branch_value), .ext_addr(ext_addr),
                       .im_instr(im_instr), .pc_next_value(pc_next_value));
  
  
  //регистры step1
  wire step1_load;   
  wire [15:0] im_instr_step1; //dest = im_instr_step1[9:8]
  wire [15:0] pc_next_value_step1;
  wire reset_step1;
  register_sload_sreset #(.W(16), .DV({`EMPTY, 10'b0})) _im_instr_step1(.i(im_instr), .l(step1_load), .clk(clock), .rst(reset_step1), .o(im_instr_step1));
  register_sload_sreset #(.W(16), .DV(0)) _pc_next_value_step1(.i(pc_next_value), .l(step1_load), .clk(clock), .rst(reset_step1), .o(pc_next_value_step1));
  
  //step2
  wire rf_w; //fromm fsm2
  wire rf_w_step4; //from register after step4
  wire [15:0] rf_wd; //from step5!
  wire [15:0] im_instr_step4; //dest == wn from step4 reg
  wire mux_rf_rn1_select, mux_rf_rn2_select; //from fsm2
  wire [15:0] rf_rd1, rf_rd2;
  cpu_step2 _cpu_step2(.clock(clock), .reset(reset), .rf_w(rf_w_step4), .rf_wd(rf_wd), .im_instr(im_instr_step1), .mux_rf_rn1_select(mux_rf_rn1_select), .mux_rf_rn2_select(mux_rf_rn2_select),
                       .dest(im_instr_step4[9:8]), .rf_rd1(rf_rd1), .rf_rd2(rf_rd2));
  
 
  wire [15:0] im_instr_mux;
  mux #(.DW(16), .CW(1)) _mux_im_instr(
    .i({im_instr_step1,`EMPTY, 10'b0}),
		.s(load_hazard_signal),
		.o(im_instr_mux)
	);
  
  wire [15:0] pc_next_value_mux;
  mux #(.DW(16), .CW(1)) _mux_pc_next_value(
    .i({pc_next_value_step1,16'b0}),
		.s(load_hazard_signal),
		.o(pc_next_value_mux)
	);
  
  wire [15:0] rf_rd1_mux;
  mux #(.DW(16), .CW(1)) _mux_rf_rd1(
    .i({rf_rd1,16'b0}),
		.s(load_hazard_signal),
		.o(rf_rd1_mux)
	);
  
  wire [15:0] rf_rd2_mux;
  mux #(.DW(16), .CW(1)) _mux_rf_rd2(
    .i({rf_rd2,16'b0}),
		.s(load_hazard_signal),
    .o(rf_rd2_mux)
	);
  
  wire rf_w_mux;
  mux #(.DW(1), .CW(1)) _mux_rf_w(
    .i({rf_w, 1'b0}),
		.s(load_hazard_signal),
    .o(rf_w_mux)
	);
  
  //регистры step2
  wire step2_load;
  wire [15:0] im_instr_step2;
  wire [15:0] pc_next_value_step2;
  wire [15:0] rf_rd1_step2, rf_rd2_step2;
  wire reset_step2, rf_w_step2;
  register_sload_sreset #(.W(16), .DV({`EMPTY, 10'b0})) _im_instr_step2(.i(im_instr_mux), .l(step2_load), .clk(clock), .rst(reset_step2), .o(im_instr_step2));
  register_sload_sreset #(.W(16), .DV(0)) _pc_next_value_step2(.i(pc_next_value_mux), .l(step2_load), .clk(clock), .rst(reset_step2), .o(pc_next_value_step2));
  register_sload_sreset #(.W(16), .DV(0)) _rf_rd1_step2(.i(rf_rd1_mux), .l(step2_load), .clk(clock), .rst(reset_step2), .o(rf_rd1_step2));
  register_sload_sreset #(.W(16), .DV(0)) _rf_rd2_step2(.i(rf_rd2_mux), .l(step2_load), .clk(clock), .rst(reset_step2), .o(rf_rd2_step2));
  register_sload_sreset #(.W(1), .DV(0)) _rf_w_step2(.i(rf_w_mux), .l(step2_load), .clk(clock), .rst(reset_step2), .o(rf_w_step2));
  
  //need for bypass
  wire [15:0] alu_out_step3;
  wire [15:0] dm_od_step4;
  wire [15:0] alu_out_step4;
  //step3
  wire [1:0] mux_alu_in1_select, mux_alu_in2_select;
  wire ext_imm_sign; //from fsm3
  wire [15:0] alu_out;
  wire alu_zero;
  wire [3:0] alu_op;// from fsm3
  cpu_step3 _cpu_step3(.clock(clock), .reset(reset), .alu_op(alu_op), .mux_alu_in1_select(mux_alu_in1_select), .mux_alu_in2_select(mux_alu_in2_select), .ext_imm_sign(ext_imm_sign), 
					   .rf_rd1(rf_rd1_step2), .rf_rd2(rf_rd2_step2), .bypass_from_alu(alu_out_step3) , .bypass_from_dm(alu_out_step4) , 
            .instr_imm(im_instr_step2[5:0]), .instr_addr(im_instr_step2[9:0]), .pc_next_value(pc_next_value_step2), 
                       .ext_addr(ext_addr), .pc_branch_value(pc_branch_value) , .alu_zero(alu_zero), .alu_out(alu_out));
  
  //регистры step3
  wire step3_load;
  wire [15:0] rf_rd1_step3;
  wire [15:0] im_instr_step3;
  wire alu_zero_step3, rf_w_step3;
  register_sload_sreset #(.W(16), .DV(0)) _rf_rd1_step3(.i(rf_rd1_step2), .l(step3_load), .clk(clock), .rst(reset), .o(rf_rd1_step3));
  register_sload_sreset #(.W(16), .DV({`EMPTY, 10'b0})) _im_instr_step3(.i(im_instr_step2), .l(step3_load), .clk(clock), .rst(reset), .o(im_instr_step3));
  register_sload_sreset #(.W(1), .DV(0)) _alu_zero_step3(.i(alu_zero), .l(step3_load), .clk(clock), .rst(reset), .o(alu_zero_step3));
  register_sload_sreset #(.W(16), .DV(0)) _alu_out_step3(.i(alu_out), .l(step3_load), .clk(clock), .rst(reset), .o(alu_out_step3));
  register_sload_sreset #(.W(1), .DV(0)) _rf_w_step3(.i(rf_w_step2), .l(step3_load), .clk(clock), .rst(reset_step3), .o(rf_w_step3));
  
  
  //step4
  wire [15:0] dm_od;
  wire dm_w; //from fsm4
  cpu_step4 _cpu_step4(.clock(clock), .reset(reset), .alu_out(alu_out_step3), .rf_rd1(rf_rd1_step3), .dm_w(dm_w), .dm_od(dm_od));
  
  //регистры step4
  wire step4_load;
  register_sload_sreset #(.W(16), .DV(0)) _alu_out_step4(.i(alu_out_step3), .l(step4_load), .clk(clock), .rst(reset), .o(alu_out_step4));
  register_sload_sreset #(.W(16), .DV(0)) _dm_od_step4(.i(dm_od), .l(step4_load), .clk(clock), .rst(reset), .o(dm_od_step4));
  register_sload_sreset #(.W(16), .DV({`EMPTY, 10'b0})) _im_instr_step4(.i(im_instr_step3), .l(step4_load), .clk(clock), .rst(reset), .o(im_instr_step4));
  register_sload_sreset #(.W(1), .DV(0)) _rf_w_step4(.i(rf_w_step3), .l(step4_load), .clk(clock), .rst(reset_step4), .o(rf_w_step4));
  
  //step5
  wire mux_rf_wd_select; //from fsm5
  cpu_step5 _cpu_step5(.clock(clock), .reset(reset), .alu_out(alu_out_step4), .dm_od(dm_od_step4), .mux_rf_wd_select(mux_rf_wd_select), .rf_wd(rf_wd));
  
  // = дополнительный мультиплексор для пересылки данных =
  
  wire stall;
  // управляющие автоматы
  fsm_step1 _fsm_step1(.reset( reset), .stall_from_step3(stall), .pc_load(pc_load), .load_step1(step1_load), .reset_step1(reset_step1), .load_hazard_signal(load_hazard_signal));
  fsm_step2 _fsm_step2(.reset( reset), .opcode(im_instr_step1[15:10]), .stall_from_step3(stall),  
                       .rf_w(rf_w), .mux_rf_rn1_select(mux_rf_rn1_select), .mux_rf_rn2_select(mux_rf_rn2_select), .load_step2(step2_load), .reset_step2(reset_step2));
  fsm_step3 _fsm_step3( .alu_zero(alu_zero), .opcode(im_instr_step2[15:10]), .funct(im_instr_step2[3:0]), .alu_op(alu_op),
                       .ext_imm_sign(ext_imm_sign), 
                       .mux_pc_branch_select(mux_pc_branch_select),
                       .stall(stall), .load_step3(step3_load));
  fsm_step4 _fsm_step4(.opcode(im_instr_step3[15:10]), .dm_w(dm_w), .load_step4(step4_load));
  fsm_step5 _fsm_step5(.opcode(im_instr_step4[15:10]), .mux_rf_wd_select(mux_rf_wd_select));
  fsm_bypass _fsm_bypass( .opcode(im_instr_step2[15:10]), .s1_step2(im_instr_step2[7:6]), .s2_step2(im_instr_step2[5:4]),
                         .t_step2(im_instr_step2[9:8]),
                         .t_step4(im_instr_step4[9:8]), .t_step3(im_instr_step3[9:8]), .rf_w_step4(rf_w_step4), .rf_w_step3(rf_w_step3),  
                         .mux_alu_in1_select(mux_alu_in1_select), .mux_alu_in2_select(mux_alu_in2_select));
  fsm_load_control _fsm_load_control(.s1_step1(im_instr_step1[7:6]), .s2_step1(im_instr_step1[5:4]), .t_step1(im_instr_step1[9:8]),
                                     .opcode_step2(im_instr_step2[15:10]), .opcode_step1(im_instr_step1[15:10]),  .opcode_step4(im_instr_step4[15:10]),
                   .t_step2(im_instr_step2[9:8]), .load_hazard_signal(load_hazard_signal));
  
endmodule
