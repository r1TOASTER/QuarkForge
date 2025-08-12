#ifndef _MMIO_H
#define _MMIO_H

#include "include/common/types.h"

uint32_t read32(uint32_t* addr);
void write32(uint32_t* addr, uint32_t val);

uint64_t read64(uint32_t* addr);
void write64(uint32_t* addr, uint64_t val);

#endif