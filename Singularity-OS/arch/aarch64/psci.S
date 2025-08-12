/*
    @brief - assembly file to control power, idle, and reset states for cores
 */

# TODO: make it go idle
.global halt_core
halt_core:
    wfi
    b       .

# TODO: if definition of function change - change in include/common/power.h as well
.global __f_cpu_reset
.type __f_cpu_reset, @function
__f_cpu_reset:
    # TODO - maybe ACPI is needed
    ret
