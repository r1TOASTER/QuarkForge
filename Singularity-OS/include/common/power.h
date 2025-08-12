#ifndef _SHUTDOWN_H
#define _SHUTDOWN_H

extern void __f_cpu_reset(void);

void __internal_abort() {
    __f_cpu_reset();
}

void abort() {
    __internal_abort();
}

#endif