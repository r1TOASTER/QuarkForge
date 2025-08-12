/*
    @brief - assembly file for register common macros
 */

#ifndef _REGS_S
#define _REGS_S

.global memzero_regs
.macro memzero_regs
.irp    n,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30
mov     x\n, xzr
.endr
.endm

.global save_regs
.macro  save_regs
# TODO - save wanted registers - push / str to memory
.endm

.global restore_regs
.macro  restore_regs
# TODO - restore saved registers (literally reverse of save if stack) - pop / ldr from memory
.endm

#endif
