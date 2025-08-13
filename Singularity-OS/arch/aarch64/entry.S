/*
    @brief - entry point of the entire system, initializtion and jumping to kernel main function
 */

.include "Singularity/arch/aarch64/reg.S"

.section ".text.entry"
.global _start

_start:
    /*
        TODO 1:
        possible hypervisor + device tree - check xN for signture (hypervisor standard should be written)
        check if has info from it - store
        later - x0 and x1 can be used for zeroing out the bss section
        cmp     x0, SIGNUTRE
        TODO 2:
        one setup core, scheduler will handle threads and SMP
    */

no_hv:
# TODO: disable trapping to EL2

hv:
# TODO: store x1 or x0 (device tree)

# zero registers after check failed (no hv / dtb info)
zero_registers:
    __m_memzero_regs

# configuring the evt address for el1 (kernel) traps, then 'flushing' the cpu to let him see the changes
evt_setup:
# TODO: configure more using SCTLR (or SCTLR_EL1)
    ldr     x0, =_evt
    msr     VBAR_EL1, x0
    isb

# TODO: check if needed and here
mmu_config:
# configure MMU

# TODO: check if needed and here
gic_setup:
# setup GIC

sp_setup:
    mov     x0, #0x8000
    msr     SP_EL1, x0

# check which core currently running, if 0 jump to kernel, else halt until scheduler changes it
cores_num:
    mrs     x0, MPIDR_EL1
    and     x0, x0, #3
    cbz     x0, self_lower_to_el1
    b       halt_core

# TODO (figure also where to put in code)
self_lower_to_el1:
# TODO: remove trapping on the regs: HCR_EL2, CPTR_EL2, HSTR_EL2
# TODO: enable access to timers on EL1
# set EL1 ES to Aarch64
    mrs     x0, HCR_EL2
    mov     x1, #1
    lsl     x1, x1, #30
    and     x0, x0, x1
    msr     HCR_EL2, x0
# set ELR to have the next label address so it would continue as el1
    ldr     x0, =zero_bss
    msr     ELR_EL2, x0
# configure SPSR with proper info
    mrs     x0, SPSR_EL2
    mov     x1, #0b0101
    and     x0, x0, x1
    msr     SPSR_EL2, x0
# drop to el1
    eret

# checking if lowering to el1 succeeded
#     check_el:
#         mrs     x0, CurrentEL
#         lsr     x0, x0, #2
#         cmp     x0, #1
#         b.EQ    zero_bss
#         b       failed_el1

zero_bss:
# load start and end address of bss section (from linker file variable exposing) and calc the offset for memzero
    ldr     x0, =_sbss
    ldr     x1, =_ebss
    sub     x1, x1, x0
    bl      memzero

# TODO: data section move to location? or just linker script will do it

call_kernel:
# TODO: setup SP (maybe before for DT and Signuture / Info from HV?)
    bl      kmain
    b       .

# failed to lower el to 1
failed_el1:
    b       .