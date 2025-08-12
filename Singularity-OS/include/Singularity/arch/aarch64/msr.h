/*
    @brief - interact with MSR registers using inline asm 
 */

#ifndef _MSR_H
#define _MSR_H

#include "Singularity/common/types.h"

#define READ_MSR(ret, reg_name) \
    asm ("mrs %0, " #reg_name : "=r" (ret))

#define WRITE_MSR(reg_name, val) \
    asm ("msr " #reg_name ", %0" :: "r" (val))

#endif