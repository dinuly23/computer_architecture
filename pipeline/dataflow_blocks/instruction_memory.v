// ********************
// *модуль instruction_memory*
// ********************
// = Входы =
// [шина] addr [16]: адрес текущей считываемой инструкции
//
// = Выходы =
// [шина] instr [16]: инструкция, располагающаяся по адресу addr
//
// = Функционирование =
// Память инструкций - это огромный мультиплексор, на входах данных которого висят 16-битные константы - машинные коды команд модельной архитектуры.
// Константы адресуются по словам ширины 16 (а не по байтам, как это обычно делается в "реальных" процессорах).
// Если хочется вписать свою программу в память инструкций, то это следует сделать непосредственно в коде модуля.
// Выходная шина непрерывно присваивается со входа и "вшитых" констант.
`include "general_architecture/asm.vh"
module instruction_memory(addr, instr);
  input [15:0] addr;
  output reg [15:0] instr;
  
  always @(*)
  begin
    instr = `ASM_NOP;
    case(addr)
     0: instr = `ASM_ADDI(2'd0, 2'd0, 6'b111111); // [-1 0 0 0]
     1: instr = `ASM_ADDIU(2'd1, 2'd1, 6'b111111); // [-1 63 0 0]
     2: instr = `ASM_ANDI(2'd0, 2'd0, 6'b111110); // [-2 63 0 0]
     3: instr = `ASM_ANDIU(2'd0, 2'd0, 6'b111111); // [62 63 0 0]
     4: instr = `ASM_ORIU(2'd0, 2'd0, 6'b100011); // [63 63 0 0]
     5: instr = `ASM_ORI(2'd0, 2'd0, 6'b100000); // [-1 63 0 0]
     6: instr = `ASM_SLTI(2'd2, 2'd0, 6'b000000); // [-1 63 1 0]
     7: instr = `ASM_SLTIU(2'd2, 2'd0, 6'b100000); // [-1 63 0 0]
     8: instr = `ASM_SW(2'd1, 2'd2, 6'b000011); // [-1 63 0 0] mem 3:63
     9: instr = `ASM_ADDI(2'd2, 2'd2, 6'b000011); // [-1 63 3 0] mem 3:63
    10: instr = `ASM_ADD(2'd2, 2'd2, 2'd0); // decrease $2 each iteration
    11: instr = `ASM_LW(2'd3, 2'd2, 6'b000001); // load 63-i each (ith) iteration to $3
    12: instr = `ASM_ADDI(2'd3, 2'd3, 6'b111111); // decrease $3
    13: instr = `ASM_SW(2'd3, 2'd2, 6'b000000); // store $3 to mem:2 / mem:1 / mem:0 / mem:-1
    14: instr = `ASM_BNE(2'd0, 2'd2, 6'b111011); // if $0 != $2 then goto 10; on out: [-1 63 -1 60]
    15: instr = `ASM_BEQ(2'd1, 2'd3, 6'b111111); // no branch
    16: instr = `ASM_BEQ(2'd0, 2'd2, 6'b000001); // branch
    17: instr = `ASM_ADDI(2'd0, 2'd0, 6'd1); // should not be executed
    18: instr = `ASM_J(10'd16); // cycle 16-18
    endcase
  end
endmodule
