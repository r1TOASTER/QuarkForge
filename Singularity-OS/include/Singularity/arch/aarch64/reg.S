/*
    @brief - assembly file for register common macros
    every macro is prefixed with __m_ -> internal for label export
 */

#ifndef _REG_S
#define _REG_S

.macro __m_memzero_regs
    .irp    n,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30
        mov     x\n, xzr
    .endr
.endm

.macro  __m_save_regs
# TODO - save wanted registers - push / str to memory
.endm

.macro  __m_restore_regs
# TODO - restore saved registers (literally reverse of save if stack) - pop / ldr from memory
.endm

#endif
