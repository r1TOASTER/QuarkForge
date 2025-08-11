.section .text
.global _start

_start:
    # possible hypervisor + device tree - check xN for signture (hypervisor standard should be written)
    # if has info from it - store
    # later - x0 and x1 can be used for zeroing out the bss section
    cmp     x0, SIGNUTRE # TODO

zero_bss:
    ldr     x0, =_sbss # start of bss section
    ldr     x1, =_ebss # end of bss section
    sub     x1, x1, x0 # offset
    bl      memzero

# TODO: data section move to location? or just linker script will do it

call_kernel:
    bl      kmain
    b       .
