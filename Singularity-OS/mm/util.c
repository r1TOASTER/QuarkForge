#include "Singularity/common/types.h"

void memset(void* addr, uint8_t val, uint32_t count) {
    uint8_t* p = (uint8_t*)addr;

    while (count--) {
        *p++ = val;
    }
}

void memzero(void* addr, uint32_t count) {    
    memset(addr, 0, count);
}