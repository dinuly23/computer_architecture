module cpu_step5(clock, reset, alu_out, dm_od, mux_rf_wd_select, rf_wd);
	input clock, reset;
   input [15:0] alu_out; //from step3
   input [15:0] dm_od;
   input mux_rf_wd_select; //from fsm
   
   output [15:0] rf_wd; 
   //mux_rf_wd
   
   // == мультиплексор: данные, записываемые в регистр ==
   mux #(.DW(16), .CW(1)) _mux_rf_wd(
       .i({alu_out, dm_od}),
       .s(mux_rf_wd_select),
       .o(rf_wd)
   );

endmodule
