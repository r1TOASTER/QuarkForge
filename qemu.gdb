# Make sure the architecture sets right
set architecture aarch64

# Use compiled and linked kernel ELF to provide symbols for GDB
file Build/Singularity-OS/Singularity-OS.elf

# Remotely connect to QEMU exposed GDB
target remote localhost:9999

# when quiting gdb - quit the qemu (quitq is now an alias)
define quitq
    monitor quit
    quit
end

# Break on entry point, -S flag in QEMU holding the CPU before first breakpoint, continue to start
break evt_setup
# it's not actually mmu config - label shenanigens - currently cpu_num
break mmu_config 
break zero_bss
break memzero