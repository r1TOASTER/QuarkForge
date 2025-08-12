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
    @brief - Macro to generate the bridge handlers that will save/restore, jump to isr and eret
    @body - 
        save registers on sp_el0
        call the isr based on the arguments el, sp and arch
        restore the registers from sp_el0
        return from the exception (eret)
 */ 

# Macro to generate bridge handlers (saving registers, jumping to isr, restoring registers, eret) - evt entries size not large enough alone
.macro __m_bridge_handler, el, sp, arch
\el\()_sp\sp\()_aarch\arch\()_bhandler:
    __m_save_volatile
    bl      \el\()_sp\sp\()_aarch\arch\()_isr
    __m_restore_volatile
    eret
.endm

# section according to the linker script
.section .evt
.global evt_table

/*
    @brief - Macro to generate EVT entries for trapping EL1 on aarch64
    @body - 
        each entry is aligned to 0x80 (entry size, padding)
        jump to a bridge handler - not enough size for save/restore etc
 */ 

.macro  __m_evt_entry type, bridge_handler
.balign 0x80
    # TODO: do a check for handling maybe - if there are exception not worthing the overhead 
    b      \bridge_handler
.endm

# evt table is aligned to 2KB according to specs
evt_table:
.balign 2048
    # el1, sp0, aarch64
    __m_evt_entry sync, el1_sp0_aarch64_bhandler
    __m_evt_entry irq, el1_sp0_aarch64_bhandler
    __m_evt_entry fiq, el1_sp0_aarch64_bhandler
    __m_evt_entry serror, el1_sp0_aarch64_bhandler

    # el1, sp1, aarch64
    __m_evt_entry sync, el1_sp1_aarch64_bhandler
    __m_evt_entry irq, el1_sp1_aarch64_bhandler
    __m_evt_entry fiq, el1_sp1_aarch64_bhandler
    __m_evt_entry serror, el1_sp1_aarch64_bhandler

    # el0, sp0, aarch64
    __m_evt_entry sync, el0_sp0_aarch64_bhandler
    __m_evt_entry irq, el0_sp0_aarch64_bhandler
    __m_evt_entry fiq, el0_sp0_aarch64_bhandler
    __m_evt_entry serror, el0_sp0_aarch64_bhandler

    # el0, sp0, aarch32
    __m_evt_entry sync, el0_sp0_aarch32_bhandler
    __m_evt_entry irq, el0_sp0_aarch32_bhandler
    __m_evt_entry fiq, el0_sp0_aarch32_bhandler
    __m_evt_entry serror, el0_sp0_aarch32_bhandler

# section according to the linker script
.section .bridge

# Generate the bridge handlers
# el1, sp0, aarch64
__m_bridge_handler el1, 0, 64
# el1, sp1, aarch64
__m_bridge_handler el1, 1, 64
# el0, sp0, aarch64
__m_bridge_handler el0, 0, 64
# el0, sp0, aarch32
__m_bridge_handler el0, 0, 32
