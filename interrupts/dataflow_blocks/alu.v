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
module alu(in1, in2, op, out, zero, carry, overflow);
  input [15:0] in1, in2;
  input [3:0] op;
  output reg [15:0] out;
  output zero;
  output reg carry;
  output reg overflow;
  
  // определение выхода out
  always @(*)
  begin 
    case(op)
    `FUNCT_ADD : begin
		out = in1 + in2;
		carry = (in1[15] & in2[15]) | (in1[15] | in2[15]) & ( 
			(in1[14] & in2[14]) | (in1[14] | in2[14]) & (  
				(in1[13] & in2[13]) | (in1[13] | in2[13]) & ( 
					(in1[12] & in2[12]) | (in1[12] | in2[12]) & ( 
						(in1[11] & in2[11]) | (in1[11] | in2[11]) & (  
							(in1[10] & in2[10]) | (in1[10] | in2[10]) & (   
								(in1[9] & in2[9]) | (in1[9] | in2[9]) & ( 
									(in1[8] & in2[8]) | (in1[8] | in2[8]) & ( 
										(in1[7] & in2[7]) | (in1[7] | in2[7]) & ( 
											(in1[6] & in2[6]) | (in1[6] | in2[6]) & (  
												(in1[5] & in2[5]) | (in1[5] | in2[5]) & ( 
												  (in1[4] & in2[4]) | (in1[4] | in2[4]) & (   
													(in1[3] & in2[3]) | (in1[3] | in2[3]) & (  
														(in1[2] & in2[2]) | (in1[2] | in2[2]) & (  
														(in1[1] & in2[1]) | (in1[1] | in2[1]) & (   
															(in1[0] & in2[0]) | (in1[0] | in2[0]))))))))))))))));
		//(in1[15]^out[15])& (in2[15]^out[15]);  
		overflow = ((in1[15] == in2[15]) && (in1[15]!= out[15])) ? 1 : 0;
	end
    `FUNCT_SUB : begin
		out = in1 - in2;
		carry = (in1 >= in2) ? 0: 1;  
		overflow = ((in1[15] != in2[15]) && (in2[15] == out[15])) ? 1 : 0;
	end
    `FUNCT_AND :begin 
		out = in1 & in2;
		carry = 0;
		overflow = 0;
	end
    `FUNCT_OR  : begin
		out = in1 | in2;
		carry = 0;
		overflow = 0;
	end
    `FUNCT_SLTU:begin
		out = (in1 < in2) ? 1 : 0;
		carry = 0;
		overflow = 0;
	end
    `FUNCT_SLT : begin 
		out = ($signed(in1) < $signed(in2)) ? 1 : 0;
	    carry = 0;
		overflow = 0;
	end
    default    : begin
		out = 16'bxxxxxxxxxxxxxxxx;
		carry = 0;
		overflow = 0;
	end
    endcase
  end
  // определение выхода zero
  assign zero = (out == 0);
endmodule
