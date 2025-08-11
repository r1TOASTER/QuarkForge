/*
    @brief - assembly file to control power, idle, and reset states
 */

.global __cpu_reset 
.type __cpu_reset, @function

__cpu_reset:
    # TODO - maybe ACPI is needed