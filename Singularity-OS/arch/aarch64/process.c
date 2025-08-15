#include "Singularity/arch/aarch64/process.h"

// spawn proc func (called from syscall)
struct proc_s* spawn_proc(uint16_t perms, struct regs_s regs, enum proc_arch_e arch, uint8_t core) {

    // before allocation - so can be returned if error
    struct proc_s* proc = NULL;

    uint8_t c_core = cores_proc_available(get_current_core());

    if (c_core == CORE_NUM) { // index of available core can be 0-3
        // proccesses list on current core is full, try other cores
        return NULL;
    }

    uint16_t c_index = proc_cur_index[c_core];

    proc = NULL; // TODO: alloc memory with size (kmalloc) 

    void* s_va = NULL; // TODO: alloc memory (check that returned value - didnt error on VA MM)
    void* e_va = NULL; // TODO: alloc memory with size (s_va + PAGE_SIZE?)

    proc->pid = c_index;
    proc->ppid = 0;
    proc->arch = arch;
    proc->start_va = s_va;
    proc->end_va = e_va;
    proc->perms = perms;
    proc->saved_regs = regs;
    proc->state = IDLE;

    // add the proc to the active processes list
    proc_list[c_core][c_index] = proc;

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

/*
    @brief - this function checks if a core can spawn another process in it
    @return - true if can use it, false otherwise
*/ 
bool __f_core_proc_available(uint8_t core) {
    uint16_t c_index = proc_cur_index[core];
    
    // looping over the cores list, if any proc->state is killable, can be replaced
    while (proc_list[core][c_index]->state != KILLABLE) { 
        c_index = NEXT_INDEX(c_index);
        // looped-back, no killables
        if (c_index == proc_cur_index[core]) {
            return FALSE;
        }
    }

    // set the new current index of the list
    proc_cur_index[core] = c_index;

    return TRUE;
}

/*
    @brief - this function checks if any core can spawn another process in it
    @return - the number of a core if can use it, CORE_NUM otherwise
*/
uint8_t cores_proc_available(uint8_t org) {
    
    for (uint8_t f = 0; f < CORE_NUM; f++) {
        
        if (__f_core_proc_available(org)) {
            return org;
        }

        org = NEXT_CORE(org);
    }

    return CORE_NUM;
}