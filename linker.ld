ENTRY(_start)

/*
    TODO: make a reasonable evt address
    TODO: add the RAM memory range for the RPi z2w
*/

SECTIONS {
    . = 0xFFFF0000;
    _evt = .;
    .vectors : {
        KEEP(*(.evt))
    }

    . = 0x80000;

    /* Code segment: readable and executable */
    .text : {
        *(.text)
        *(.text.*)
    }
    . = ALIGN(4K);

    /* Read-only data segment */
    .rodata : {
        *(.rodata)
    }
    . = ALIGN(4K);

    /* Writable data segment */
    .data : {
        *(.data)
    }
    . = ALIGN(4K);

    /* Uninitialized data segment */
    .bss : {
        *(.bss)
    }
    . = ALIGN(4K);

    /* Discard unnecessary sections */
    /DISCARD/ : {
        *(.comment)
        *(.gnu*)
        *(.note*)
        *(.test_cases)
    }
}