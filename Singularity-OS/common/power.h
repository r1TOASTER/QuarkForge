#ifndef _SHUTDOWN_H
#define _SHUTDOWN_H

void __internal_abort() {
    __cpu_reset();
}

void abort() {
    __internal_abort();
}

#endif