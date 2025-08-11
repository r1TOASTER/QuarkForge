#ifndef _SHUTDOWN_H
#define _SHUTDOWN_H

#include "arch/aarch64/psci.S"

void __internal_abort() {
    __cpu_reset();
}

void abort() {
    __internal_abort();
}

#endif