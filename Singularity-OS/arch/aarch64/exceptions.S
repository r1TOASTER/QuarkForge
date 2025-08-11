/*
    @brief - the evt is the exception vectors table - holding the instructions on each exception that should happen - on aarch64 mode
    the entry evt is 2048 (2k) bytes aligned, each entry 0x80 (32 instructions)
    every exception label has it's own explenations (divided to 4 groups - each has Sync, IRQ, FIQ and SError)

    first group - cur_el_sp_el0 - exception made from the same EL (EL1 -> EL1), and using the SP of EL0
    second group - cur_el_sp_elx - exception made from the same EL (EL1 -> EL1), and using the SP of the same EL (EL1 -> EL1)
    third group - low_el_aarch64 - exception made from lower EL (only EL0), the arch that made the exception is aarch64
    fourth group - low_el_aarch32 - exception made from lower EL (only EL0), the arch that made the exception is aarch32
 */

# save/restore regs macro
.include "arch/aarch64/reg.S"

# the macro will save registers, call the handler, restore the registers and eret
.macro  evt_entry name, el, sp, handler, arch
.balign 2048
# check if the entry should even be generated - current EL should raise only specific exceptions
.if     \el == 0    
save_regs
bl      handler
restore_regs      
.else
b       handler
.endif
eret
.endm

evt_entry sync, 1, 0, default_handler, 64
evt_entry irq, 1, 0, default_handler, 64
evt_entry fiq, 1, 0, default_handler, 64
evt_entry serror, 1, 0, default_handler, 64

evt_entry sync, 1, 1, default_handler, 64
evt_entry irq, 1, 1, default_handler, 64
evt_entry fiq, 1, 1, default_handler, 64
evt_entry serror, 1, 1, default_handler, 64

evt_entry sync, 0, 0, default_handler, 64
evt_entry irq, 0, 0, default_handler, 64
evt_entry fiq, 0, 0, default_handler, 64
evt_entry serror, 0, 0, default_handler, 64

evt_entry sync, 0, 0, default_handler, 32
evt_entry irq, 0, 0, default_handler, 32
evt_entry fiq, 0, 0, default_handler, 32
evt_entry serror, 0, 0, default_handler, 32

# TODO - handlers

default_handler:
    nop