`include "general_architecture/funct.vh"
`include "general_architecture/opcodes.vh"

module fsm_bypass( opcode, s1_step2, s2_step2, t_step2, t_step4, t_step3, rf_w_step4, rf_w_step3,  
				mux_alu_in1_select, mux_alu_in2_select);

	
	/* s1 - first argument, s2 - second argument, t- result register, rf_w- signal to write for rf
	this fsm solves data hazards with read-after-write
	step2 = ID/EX; step3 = EX/MEM; step4= MEM/WB 
	*/
	input [5:0] opcode; //
	input [1:0] s1_step2, s2_step2, t_step2;
	input [1:0] t_step4, t_step3;
	input rf_w_step4, rf_w_step3;
	output reg [1:0] mux_alu_in1_select, mux_alu_in2_select;
	
	always @(*)
	begin
		mux_alu_in1_select = 2'b00;
		if(opcode == `OPCODE_LW ||
		   opcode == `OPCODE_SW) mux_alu_in1_select = 2'b01;
		
		//step2 = ID/EX; step3 = EX/MEM; step4= MEM/WB
		if((rf_w_step4) && !((rf_w_step3) && (t_step3 == s1_step2) ) &&
		   t_step4 == s1_step2)
			begin
				mux_alu_in1_select = 2'b11;
			end
		if(rf_w_step3  && (t_step3 == s1_step2))
			begin
				mux_alu_in1_select = 2'b10;
			end
		//s1 for BI == t[9:8] , s2 for BI = s1[7:6]
		if((opcode == opcode == `OPCODE_BEQ || opcode == `OPCODE_BNE) && 
		   (rf_w_step4) && !((rf_w_step3) && (t_step3 == t_step2) ) &&
		   t_step4 == t_step2 )  
			begin 
				mux_alu_in1_select = 2'b11;
			end
		if((opcode == opcode == `OPCODE_BEQ || opcode == `OPCODE_BNE) && 
		   rf_w_step3  && (t_step3 == t_step2))  
			begin 
				mux_alu_in1_select = 2'b10;
			end
	
		if(opcode == `EMPTY) mux_alu_in1_select = 2'b00;
	end

	always @(*)
	begin
		mux_alu_in2_select = 2'b00;
	
		//step2 = ID/EX; step3 = EX/MEM; step4= MEM/WB
		if((rf_w_step4) && !((rf_w_step3) && (t_step3 == s2_step2) ) &&
		   t_step4 == s2_step2)
			begin
				mux_alu_in2_select = 2'b11;
			end
		if(rf_w_step3 && (t_step3 == s2_step2))
			begin
				mux_alu_in2_select = 2'b10;
			end		
		//s1 for BI == t[9:8] , s2 for BI = s1[7:6]
		if((opcode == opcode == `OPCODE_BEQ || opcode == `OPCODE_BNE) && 
		   (rf_w_step4) && !((rf_w_step3) && (t_step3 == s1_step2) ) &&
		   t_step4 == t_step2)  
			begin 
				mux_alu_in2_select = 2'b11;
			end
		if((opcode == opcode == `OPCODE_BEQ || opcode == `OPCODE_BNE) && 
		   rf_w_step3  && (t_step3 == s1_step2))  
			begin 
				mux_alu_in2_select = 2'b10;
			end	
		if(opcode == `EMPTY) mux_alu_in2_select = 2'b00;
		
		if(opcode == `OPCODE_ADDIU ||
		   opcode == `OPCODE_ADDI ||
		   opcode == `OPCODE_ANDIU ||
		   opcode == `OPCODE_ANDI ||
		   opcode == `OPCODE_ORIU ||
		   opcode == `OPCODE_ORI ||
		   opcode == `OPCODE_SLTIU ||
		   opcode == `OPCODE_SLTI ||
		   opcode == `OPCODE_LW ||
		   opcode == `OPCODE_SW) mux_alu_in2_select = 2'b01;		
	end
	
endmodule
	