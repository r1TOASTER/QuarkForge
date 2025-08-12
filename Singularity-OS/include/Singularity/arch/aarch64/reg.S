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

# using SP_EL0 and atomic instructions to save registers
.macro __m_save_volatile, el
# x9-x15 can be corrupted (non saved)
# saving SPSR (for PSTATE) and ELR (for eret)
    add     SP_EL0, SP_EL0, #192
    .irp    n,0,1,2,3,4,5,6,7,8
        str     x\n, [SP_EL0, #\n*8]!
    .endr
    .irp    n,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30
    .set    n, \n-7
        str     x\n, [SP_EL0, #\n*8]!
    .endr
    str     SPSR_EL\el, [SP_EL0, #176]!
    str     ELR_EL\el, [SP_EL0, #184]!
.endm

# using SP_EL0 and atomic instruction to restore registers
.macro __m_restore_volatile
    .irp    n,0,1,2,3,4,5,6,7,8
        ldr     x\n, [SP_EL0, #\n*8]!
    .endr
    .irp    n,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30
    .set    n, \n-7
        ldr     x\n, [SP_EL0, #\n*8]!
    .endr
    ldr     SPSR_EL\el, [SP_EL0, #176]!
    ldr     ELR_EL\el, [SP_EL0, #184]!
    sub     SP_EL0, SP_EL0, #192
.endm

# using SP_EL0 to save registers
.macro  __m_save_regs
# TODO - save wanted registers - push / str to memory
.endm

# using SP_EL0 to restore registers
.macro  __m_restore_regs
# TODO - restore saved registers (literally reverse of save if stack) - pop / ldr from memory
.endm

#endif
