#include "Singularity/arch/aarch64/power.h"

void __f_abort() {
    __f_cpu_reset();
}

void abort() {
    __f_abort();
}