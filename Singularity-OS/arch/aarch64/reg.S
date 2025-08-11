/*
    @brief - assembly file for register common macros
 */

.global memzero_regs
.macro memzero_regs
.irp    n,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30
mov     x\n, xzr
.endr
.endm

# TODO:
.global save_regs
.macro  save_regs
.irp    n,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30
# push / str to memory
.endr
.endm

# TODO:
.global restore_regs
.macro  restore_regs
.irp    n,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30
# pop / ldr from memory
.endr
.endm
