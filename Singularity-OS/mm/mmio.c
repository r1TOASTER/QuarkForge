#include "Singularity/mm/mmio.h"

uint32_t read32(uint32_t* addr) {
    uint32_t ret = 0;
    
    asm volatile("ldr %0, [%1]"
        : "=r" (ret)
        : "r" (addr));

    return ret;
}

void write32(uint32_t* addr, uint32_t val) {
    asm volatile("str %0, [%1]"
        : 
        : "r" (val), "r" (addr));
}

uint64_t read64(uint32_t* addr) {
    uint64_t ret = 0;
    
    asm volatile("ldr %0, [%1]"
        : "=r" (ret)
        : "r" (addr));

    return ret;
}

void write64(uint32_t* addr, uint64_t val) {
    asm volatile("str %0, [%1]"
        : 
        : "r" (val), "r" (addr));
}