#include "Singularity/arch/aarch64/process.h"

// spawn proc func (called from syscall)
struct proc_s* spawn_proc(uint16_t perms, void* regs, enum proc_arch_e arch, uint8_t core) {

    // before allocation - so can be returned if error
    struct proc_s* proc = NULL;

    // provided core doesnt mean can run process on it
    uint8_t c_core = core;

    // TODO: check that proccesses lists are not full, other cores as well
    if (NULL) {
        // proccesses list on current core is full, try other cores
        return NULL;
    }

    uint16_t c_index = proc_cur_index[c_core];

    // check that can be inserted in the next index (that they are not full doesnt gurentee next spot open) 
    // not a loop trap - checked that the core availble
    // TODO: maybe make a func that will return available index with this loop inside + a check already?
    while (proc_list[c_core][c_index++]->state != KILLABLE) { }
    // incremented after the check - if KILLABLE on process 0, c_index would be 1
    c_index--;

    // update the current index
    proc_cur_index[c_core] = c_index;

    void* s_va = NULL; // TODO: alloc memory (check that returned value - didnt error on VA MM)
    void* e_va = NULL; // TODO: alloc memory with size (s_va + PAGE_SIZE?)

    proc = NULL; // TODO: alloc memory with size (kmalloc) 

    proc->pid = c_index;
    proc->ppid = 0;
    proc->arch = arch;
    proc->start_va = s_va;
    proc->end_va = e_va;
    proc->perms = perms;
    proc->saved_regs = regs;
    proc->state = IDLE;

    // add the proc to the active processes list
    proc_list[c_core][proc->pid] = proc;

    return proc;
}

// kill proc func (can be used always with the sched / syscall)
void kill_proc(uint16_t pid) {}

// index proc from current core (get from the array using pid as index)
struct proc_s* get_proc(uint16_t index) {}

// get current proc for current core
struct proc_s* get_current_proc() {}

// spawn child proc
struct proc_s* spawn_child(uint16_t ppid, uint16_t perms, void* regs, enum proc_arch_e arch) {}

// kill child proc
void kill_child(uint16_t ppid, uint16_t pid) {}