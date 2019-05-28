`ifndef __ASM_VH
`define __ASM_VH

// Здесь хранятся макроопределения для удобного написания инструкций модельной архитектуры в машинном коде для использования в памяти инструкций.
// Названия макроопеределений говорят сами за себя.
// Порядок аргументах в макроопределениях - как в ассемблерной записи.

`include "general_architecture/opcodes.vh"
`include "general_architecture/funct.vh"

`define ASM_ADD(T, S1, S2) {`OPCODE_AR, T, S1, S2, `FUNCT_ADD}
`define ASM_SUB(T, S1, S2) {`OPCODE_AR, T, S1, S2, `FUNCT_SUB}
`define ASM_AND(T, S1, S2) {`OPCODE_AR, T, S1, S2, `FUNCT_AND}
`define ASM_OR(T, S1, S2)  {`OPCODE_AR, T, S1, S2, `FUNCT_OR}
`define ASM_SLTU(T, S1, S2) {`OPCODE_AR, T, S1, S2, `FUNCT_SLTU}
`define ASM_SLT(T, S1, S2) {`OPCODE_AR, T, S1, S2, `FUNCT_SLT}

`define ASM_ADDIU(T, S, IMM) {`OPCODE_ADDIU, T, S, IMM}
`define ASM_ADDI(T, S, IMM) {`OPCODE_ADDI, T, S, IMM}
`define ASM_ANDIU(T, S, IMM) {`OPCODE_ANDIU, T, S, IMM}
`define ASM_ANDI(T, S, IMM) {`OPCODE_ANDI, T, S, IMM}
`define ASM_ORIU(T, S, IMM) {`OPCODE_ORIU, T, S, IMM}
`define ASM_ORI(T, S, IMM) {`OPCODE_ORI, T, S, IMM}
`define ASM_SLTIU(T, S, IMM) {`OPCODE_SLTIU, T, S, IMM}
`define ASM_SLTI(T, S, IMM) {`OPCODE_SLTI, T, S, IMM}

`define ASM_BEQ(S1, S2, IMM)  {`OPCODE_BEQ, S1, S2, IMM}
`define ASM_BNE(S1, S2, IMM)  {`OPCODE_BNE, S1, S2, IMM}

`define ASM_LW(T, S, IMM) {`OPCODE_LW, T, S, IMM}
`define ASM_SW(T, S, IMM) {`OPCODE_SW, T, S, IMM}

`define ASM_J(IMM) {`OPCODE_J, IMM}

`define ASM_NOP {`OPCODE_ADDI, 2'b0, 2'b0, 6'b0}
`define ASM_INTERRUPTS_J {`INTERRUPTS_J, 10'b0}
`define ASM_INTERRUPTS_ADDR {`INTERRUPTS_ADDR, 10'b0}
`define ASM_SYSCALL {`SYSCALL, 10'b0}


`endif // __ASM_VH
