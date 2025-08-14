#ifndef _PROCESS_H
#define _PROCESS_H

#include "Singularity/common/types.h"

// keeping track of the current array index
uint16_t proc32_cur_index = 0;
uint16_t proc64_cur_index = 0;

// spawn proc func (called from syscall)
// kill proc func (can be used always with the sched / syscall)
// index proc (get from the array using pid as index)
// get current proc?
// spawn child proc
// kill child proc
// modify proc?

/*
    TODOs:
    - utility to spawn a process (should be later for a syscall / ipc request) - add to active list
    - utility to kill a process - remove from active list
    
    - utility to spawn a child process (advanced) - add to active list, maybe a child list
    - utility to kill child and return from a child process (advanced) - remove from active list, maybe a child list
    
    - utility to modify a processes info (to be from a syscall / ipc I guess)
*/

// enum to describe the arch of the current process
enum proc_arch_e {
    AARCH32,
    AARCH64
} proc_arch_e;

// enum to describe current process state - scheduling-wise
enum proc_state_e {
    RUNNING, // currently running on core
    IDLE, // can be scheduled
    BLOCKED, // waiting for a blocked operation to end (io etc)
    KILLABLE, // TODO: is this needed? for upcoming work - if a process calles exit, will trigger syscall to terminate, I guess not needed
} proc_state_e;

// General Purpose Registers count for saved
#define GPR_COUNT (24)

// struct to save context of a process - aarch32
struct context32_s {
    uint32_t gprs[GPR_COUNT]; // x0-x30, without x9-x15
    uint32_t spsr;
    uint32_t elr;
} context32_s;

// struct to save context of a process - aarch64
struct context64_s {
    uint64_t gprs[GPR_COUNT]; // x0-x30, without x9-x15
    uint64_t spsr;
    uint64_t elr;
} context64_s;

// struct of a process needed information
struct proc_s {
    uint32_t pid;
    uint32_t ppid;

    // TODO: void ptr? size of writing to pages / memory layout todo
    void* start_va;
    void* end_va;

    // TODO: make sure process permissions user? and can be hold inside 16-bit
    uint16_t perms;

    // holding a ptr to regs based on aarch field
    void* saved_regs;
    enum proc_state_e state;
    // TODO: the page address where the saved info is stored?
    void* owner_page;
} proc_s;

#define PROCESSES_MAX (4096) // 4096 max processes per core = 16384 total
struct proc_s proc_list[PROCESSES_MAX] = { 0 };

#endif