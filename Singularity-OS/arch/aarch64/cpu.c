#include "Singularity/arch/aarch64/cpu.h"

uint8_t get_current_core() {
    uint64_t mpidr;
    READ_MSR(mpidr, MPIDR_EL1);
    return (uint8_t)(mpidr & 0x3);
}