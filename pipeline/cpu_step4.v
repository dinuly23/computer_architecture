module cpu_step4(clock, reset, alu_out, rf_rd1, dm_w, dm_od);
	input clock, reset;
	input [15:0] alu_out;
	input [15:0] rf_rd1; //from step2
	input dm_w; //from fsm
	
	output [15:0] dm_od;
	// == dm ==

   // == память данных ==

   wire dm_w;
   data_memory _data_memory(
       .addr(alu_out),
       .id(rf_rd1),
       .clk(clock),
       .w(dm_w),
       .od(dm_od)
   );
  





endmodule
