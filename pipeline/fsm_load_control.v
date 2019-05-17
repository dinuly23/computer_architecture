module fsm_load_control(s1_step1, s2_step1,t_step1, opcode_step2, opcode_step1, opcode_step4, t_step2, load_hazard_signal);
	input [1:0] s1_step1;
	input [1:0] s2_step1;
	input [1:0] t_step1; 
	input [5:0] opcode_step2;
	input [5:0] opcode_step1;
	input [5:0] opcode_step4;
	input [1:0] t_step2;
	output reg load_hazard_signal;
	
	reg [1:0] state;
	
	always @(*)
	begin 
		case(state)
		2'b00:
			begin
				load_hazard_signal = 0; 
				if((opcode_step2 == `OPCODE_LW) && ((t_step2 == s1_step1) || 
													((t_step2 == s2_step1) && !(opcode_step1 == `OPCODE_ADDIU ||
				   opcode_step1 == `OPCODE_ADDI || opcode_step1 == `OPCODE_ANDIU ||
				   opcode_step1 == `OPCODE_ANDI || opcode_step1 == `OPCODE_ORIU || opcode_step1 == `OPCODE_ORI ||
				   opcode_step1 == `OPCODE_SLTIU || opcode_step1 == `OPCODE_SLTI ||
				   opcode_step1 == `OPCODE_LW || opcode_step1 == `OPCODE_SW))))
					begin
						load_hazard_signal = 1;
					end
				if((opcode_step2 == `OPCODE_LW)  &&  (opcode_step1 == `OPCODE_BEQ || opcode_step1 == `OPCODE_BNE) &&  
				   ((t_step2 == t_step1) || (t_step2 == s1_step1)))
					begin
						load_hazard_signal = 1;
					end
				state = (load_hazard_signal) ? 2'b01 : 2'b00;
			end
		2'b01:
			begin
				if(opcode_step4 == `OPCODE_LW) load_hazard_signal = 0;
				state= (opcode_step4 == `OPCODE_LW) ? 2'b00 : 2'b01;
			end
			
		endcase
	end
endmodule