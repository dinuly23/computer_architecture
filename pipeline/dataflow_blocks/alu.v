// ************
// *модуль alu*
// ************
// = Входы =
// [шина] in1 [16]: входное число, первый аргумент.
// [шина] in2 [16]: входное число, второй аргумент.
// [шина] op  [4 ]: код арифметико-логической операции, производимой над входными числами.
//
// = Выходы =
// [шина] out  [16]: шина, на которую непрерывно выдаётся результат применения операции с кодом op к входным данным in1, in2.
// [бит ] zero     : "zero == 1" <=> "out == 0"
`include "general_architecture/funct.vh"
module alu(in1, in2, op, out, zero);
  input [15:0] in1, in2;
  input [3:0] op;
  output reg [15:0] out;
  output zero;
  
  // определение выхода out
  always @(*)
  begin 
    case(op)
    `FUNCT_ADD : out = in1 + in2;
    `FUNCT_SUB : out = in1 - in2;
    `FUNCT_AND : out = in1 & in2;
    `FUNCT_OR  : out = in1 | in2;
    `FUNCT_SLTU: out = (in1 < in2) ? 1 : 0;
    `FUNCT_SLT : out = ($signed(in1) < $signed(in2)) ? 1 : 0;
    default    : out = 16'bxxxxxxxxxxxxxxxx;
    endcase
  end
  // определение выхода zero
  assign zero = (out == 0);
endmodule
