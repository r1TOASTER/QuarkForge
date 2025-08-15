#ifndef _CPU_H
#define _CPU_H

#include "Singularity/common/types.h"
#include "Singularity/arch/aarch64/msr.h"

// number of cores available total
#define CORE_NUM (4)
// macro for getting the next core's num
#define NEXT_CORE(x) ((++x) % CORE_NUM)

// TODO: get core num func
uint8_t get_current_core();

#endif