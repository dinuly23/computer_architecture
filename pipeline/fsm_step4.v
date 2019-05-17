`include "general_architecture/funct.vh"
`include "general_architecture/opcodes.vh"

module fsm_step4(opcode, dm_w, load_step4);

	input [5:0] opcode; 
	output reg dm_w;
	output load_step4;
	
	always @(*)
	begin
		dm_w = 0;
		if(opcode == `OPCODE_SW) dm_w = 1;
		if(opcode == `EMPTY) dm_w = 0;
	end
	
	assign load_step4 = 1;
	
endmodule