#include "common/types.h"

void memzero(void* addr, uint32_t count) {    
    char* p = (char*)addr;

    while (--count) {
        *p++ = 0;
    }
}