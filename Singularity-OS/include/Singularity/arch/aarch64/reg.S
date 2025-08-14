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
.macro __m_save_regs
# x9-x15 can be corrupted (non saved)
# reading the SP_EL0 to use it as storage index
    mrs     x9, SP_EL0
# reading the MSRs to store them
    mrs     x10, SPSR_EL1
    mrs     x11, ELR_EL1

    sub     x9, x9, #208
# updating the new SP_EL0
    msr     SP_EL0, x9
    .irp    n,0,1,2,3,4,5,6,7,8
        str     x\n, [x9, #8*(\n)]!
    .endr
    .irp    n,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30
        str     x\n, [x9, #8*(\n-7)]!
    .endr
    str     x10, [x9, #192]!
    str     x11, [x9, #200]!
.endm

# using SP_EL0 and atomic instruction to restore registers
.macro __m_restore_regs
# x9-x15 can be corrupted (non saved)
    mrs     x9, SP_EL0
    .irp    n,0,1,2,3,4,5,6,7,8
        ldr     x\n, [x9, #8*(\n)]!
    .endr
    .irp    n,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30
        ldr     x\n, [x9, #8*(\n-7)]!
    .endr
    ldr     x10, [x9, #192]!
    ldr     x11, [x9, #200]!
    add     x9, x9, #208
# writing the new / loaded values to the MSRs
    msr     SP_EL0, x9
    msr     SPSR_EL1, x10
    msr     ELR_EL1, x11
.endm

/* 
    TODO: add dynamic SPSR and ELR configuration - for schedualing and running different process
    eg. process1 is running, timer interrupt, process2 should be running - cant return to process1 context and address
*/
/*
    TODO: change save / restore location memory dynamically with some function of getting correct thread page (or core)
    first save to page, then save using kernel stack to process / thread struct
    dont forget to free the memory from the temporarly storage (state page) for the next exception
 */
 /*
    TODO: figure if to save / restore x9-x15 as well
    if so, change in process.h GPR_NUM
  */
/*
    TODO: change to store / load in pairs: stp and ldp
 */

#endif
