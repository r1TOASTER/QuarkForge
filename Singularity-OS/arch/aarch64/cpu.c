#include "Singularity/arch/aarch64/cpu.h"

uint8_t get_current_core() {
    uint8_t core; 
    __asm__ ("mrs     %0, MPIDR_EL1\n"
             "and     %0, %0, #3"
             : "=r" (core));
    return core;    
}