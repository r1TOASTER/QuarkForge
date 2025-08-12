/*
    @brief - assembly file to control power, idle, and reset states for cores
 */


#ifndef _PSCI_S
#define _PSCI_S

# TODO: make it go idle
.global halt_core
halt_core:
    wfi
    b       .

.global __cpu_reset 
.type __cpu_reset, @function
__cpu_reset:
    # TODO - maybe ACPI is needed
    ret

#endif
