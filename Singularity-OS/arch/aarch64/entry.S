/*
    @brief - entry point of the entire system, initializtion and jumping to kernel main function
 */

.include "Singularity/arch/aarch64/reg.S"

.section .text
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
# zero registers after check failed (no hv / dtb info)
zero_registers:
    __m_memzero_regs

# configuring the evt address for el1 (kernel) traps, then 'flushing' the cpu to let him see the changes
evt_setup:
# TODO: configure more using SCTLR (or SCTLR_EL1)
    ldr     x0, =_evt
    lsl     x0, x0, #11
    msr     VBAR_EL1, x0
    isb

self_lower_to_el1:
# TODO

zero_bss:
    # load start and end address of bss section (from linker file variable exposing) and calc the offset for memzero
    ldr     x0, =_sbss
    ldr     x1, =_ebss
    sub     x1, x1, x0
    bl      memzero

# TODO: data section move to location? or just linker script will do it

# check which core currently running, if 0 jump to kernel, else halt until scheduler changes it
cores_num:
    mrs     x0, MPIDR_EL1
    and     x0, x0, #3
    cbz     x0, call_kernel
    b       halt_core

call_kernel:
# TODO: setup sp and go down to EL1 (if not provided by HV)
    bl      kmain
    b       .
