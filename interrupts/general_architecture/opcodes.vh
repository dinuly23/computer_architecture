`ifndef __OPCODES_VH
`define __OPCODES_VH

// Здесь хранятся макроопределения для кодов операций модельной архитектуры.
// Названия говорят сами за себя.
`define OPCODE_AR       6'b000000
`define OPCODE_ADDIU 	6'b101000
`define OPCODE_ADDI  	6'b101001
`define OPCODE_ANDIU 	6'b100100
`define OPCODE_ANDI  	6'b100101
`define OPCODE_ORIU  	6'b100110
`define OPCODE_ORI   	6'b100111
`define OPCODE_SLTIU 	6'b100010
`define OPCODE_SLTI  	6'b100011
`define OPCODE_BEQ   	6'b000010
`define OPCODE_BNE   	6'b000011
`define OPCODE_LW    	6'b000100
`define OPCODE_SW    	6'b000101
`define OPCODE_J     	6'b000001

`define EMPTY        	6'b111111
`define SYSCALL      	6'b111110
`define INTERRUPTS_J 	6'b111101

//INTERRUPTS_ADDR -- +1 к адресу возврата
`define INTERRUPTS_ADDR 6'b111100  

`endif // __OPCOEDS_VH
