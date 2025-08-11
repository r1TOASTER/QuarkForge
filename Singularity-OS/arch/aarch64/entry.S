.section .text
.global _start

_start:
    # TODO!
    # possible hypervisor + device tree - check xN for signture (hypervisor standard should be written)
    # check if has info from it - store
    # later - x0 and x1 can be used for zeroing out the bss section
    # cmp     x0, SIGNUTRE

zero_bss:
    # load start and end address of bss section (from linker file variable exposing) and calc the offset for memzero
    ldr     x0, =_sbss
    ldr     x1, =_ebss
    sub     x1, x1, x0
    bl      memzero

# TODO: data section move to location? or just linker script will do it

call_kernel:
    bl      kmain
    b       .
