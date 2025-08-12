#ifndef _MEMUTIL_H
#define _MEMUTIL_H

#include "Singularity/common/types.h"

void memset(void* addr, uint8_t val, uint32_t count);
inline void memzero(void* addr, uint32_t count);

#endif