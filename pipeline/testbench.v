module testbench;
  reg clock, reset;
  cpu _cpu(.clock(clock), .reset(reset));
 
  initial _cpu._fsm_load_control.state= 2'b00;
  initial clock = 0;
  always #1 clock = ~clock;
  initial
  begin
    $dumpfile("out.vcd");
    $dumpvars(0, testbench);
  end
  initial
  begin
    #1
    reset = 1;
    #4
    reset = 0;
    #100;
    $finish;
  end
endmodule
