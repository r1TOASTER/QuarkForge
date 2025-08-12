/*
    @brief - the evt is the exception vectors table - holding the instructions on each exception that should happen - on aarch64 mode
    the entry evt is 2048 (2k) bytes aligned, each entry 0x80 (32 instructions)
    every exception label has it's own explenations (divided to 4 groups - each has Sync, IRQ, FIQ and SError)

    first group - cur_el_sp_el0 - exception made from the same EL (EL1 -> EL1), and using the SP of EL0
    second group - cur_el_sp_elx - exception made from the same EL (EL1 -> EL1), and using the SP of the same EL (EL1 -> EL1)
    third group - low_el_aarch64 - exception made from lower EL (only EL0), the arch that made the exception is aarch64
    fourth group - low_el_aarch32 - exception made from lower EL (only EL0), the arch that made the exception is aarch32
 */

.include "Singularity/arch/aarch64/reg.S"

/*
    @brief - Macro to generate EVT entries for trapping EL1 on aarch64
    @body - 
        each entry is aligned to 0x80 (entry size, padding)
        in the case of a normal exception:
            save registers, call the handler, restore the registers and eret
        else: 
            just call the handler and eret
        TODO: making sure this logic makes sense
 */ 
.macro  __m_evt_entry name, el, sp, handler, arch
.balign 0x80
    # check if the entry should even be generated - current EL should raise only specific exceptions
    .if     \el == 0    
        __m_save_regs
        bl      \handler
        __m_restore_regs      
    .else
        b       \handler
    .endif
        eret
.endm

# section according to the linker script
.section .evt
.global evt_table

# evt table is aligned to 2KB according to specs
evt_table:
.balign 2048
# el1, sp0, aarch64
__m_evt_entry sync, 1, 0, default_handler, 64
__m_evt_entry irq, 1, 0, default_handler, 64
__m_evt_entry fiq, 1, 0, default_handler, 64
__m_evt_entry serror, 1, 0, default_handler, 64

# el1, sp1, aarch64
__m_evt_entry sync, 1, 1, default_handler, 64
__m_evt_entry irq, 1, 1, default_handler, 64
__m_evt_entry fiq, 1, 1, default_handler, 64
__m_evt_entry serror, 1, 1, default_handler, 64

# TODO: make sure using sp0
# el0, sp0, aarch64
__m_evt_entry sync, 0, 0, default_handler, 64
__m_evt_entry irq, 0, 0, default_handler, 64
__m_evt_entry fiq, 0, 0, default_handler, 64
__m_evt_entry serror, 0, 0, default_handler, 64

# TODO: make sure using sp0
# el0, sp0, aarch32
__m_evt_entry sync, 0, 0, default_handler, 32
__m_evt_entry irq, 0, 0, default_handler, 32
__m_evt_entry fiq, 0, 0, default_handler, 32
__m_evt_entry serror, 0, 0, default_handler, 32

# TODO - handlers

default_handler:
    nop