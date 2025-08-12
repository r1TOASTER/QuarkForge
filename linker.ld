ENTRY(_start)

/*
    TODO: add the RAM memory range for the RPi z2w
*/

SECTIONS {
    
    . = 0x80000;
    
    /* Code segment: readable and executable */
    .text : {
        *(.text.entry)
        *(.text)
    }
    . = ALIGN(2K);

    _evt = .;
    .vectors : {
        KEEP(*(.evt))
        KEEP(*(.bridge))
    }
    . = ALIGN(4K);

    /* Read-only data segment */
    .rodata : {
        *(.rodata)
    }
    . = ALIGN(4K);

    /* Writable data segment */
    _sdata = .;
    .data : {
        *(.data)
    }
    . = ALIGN(4K);
    _edata = .;

    /* Uninitialized data segment */
    _sbss = .;
    .bss : {
        *(.bss)
    }
    . = ALIGN(4K);
    _ebss = .;

    /* Discard unnecessary sections */
    /DISCARD/ : {
        *(.comment)
        *(.gnu*)
        *(.note*)
        *(.test_cases)
    }
}