#ifndef _PROCESS_H
#define _PROCESS_H

#include "Singularity/common/types.h"
#include "Singularity/arch/aarch64/cpu.h"

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
    uint16_t pid;
    uint16_t ppid;

    // arch size
    enum proc_arch_e arch;

    // TODO: void ptr? size of writing to pages / memory layout todo
    void* start_va;
    void* end_va;

    // TODO: make sure process permissions user? and can be hold inside 16-bit
    uint16_t perms;

    // holding a ptr to regs based on aarch field
    // TODO: maybe not a void*
    void* saved_regs;
    enum proc_state_e state;
} proc_s;

// define the processes list, with it's maximum capacity
#define PROCESSES_MAX (4096) // 4096 max processes per core = 16384 total (4 cores)
struct proc_s* proc_list[CORE_NUM][PROCESSES_MAX] = { 0 };
// keeping track of the current array index
uint16_t proc_cur_index[CORE_NUM] = { 0 };
uint16_t proc_list_size[CORE_NUM] = { 0 };

// spawn proc func (called from syscall)
struct proc_s* spawn_proc(uint16_t perms, void* regs, enum proc_arch_e arch, uint8_t core);

// kill proc func (can be used always with the sched / syscall)
void kill_proc(uint16_t pid);

// index proc from current core (get from the array using pid as index)
struct proc_s* get_proc(uint16_t index);

// get current proc for current core
struct proc_s* get_current_proc();

// spawn child proc
struct proc_s* spawn_child(uint16_t ppid, uint16_t perms, void* regs, enum proc_arch_e arch);

// kill child proc
void kill_child(uint16_t ppid, uint16_t pid);

// modify proc?

#endif