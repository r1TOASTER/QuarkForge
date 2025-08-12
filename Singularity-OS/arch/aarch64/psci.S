/*
    @brief - assembly file to control power, idle, and reset states for cores
 */


# TODO: make it go idle
.global halt_core
halt_core:
    wfi
    b       .

.global __cpu_reset 
.func __cpu_reset
__cpu_reset:
    # TODO - maybe ACPI is needed
.endfunc
