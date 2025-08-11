#include "common/types.h"

void memzero(void* addr, uint32_t count) {
    if (count < 0) return;
    
    char* p = (char*)addr;

    while (--count) {
        *p++ = 0;
    }
}