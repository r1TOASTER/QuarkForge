# Quanta-HV & Singularity-OS: Types and Naming Conventions

This document defines the standard naming conventions used across both the Quanta Hypervisor (Quanta-HV) and Singularity Operating System (Singularity-OS) projects to maintain consistency and clarity in code.

---

## Prefixes

| Prefix   | Usage                         | Description                            |
| -------- | ----------------------------- | ------------------------------------ |
| `__m_`   | Assembly macros               | Used for macros defined in assembly (`.S`) files. Example: `__m_memzero_regs` |
| `__f_`   | Kernel internal functions     | Used for functions defined inside the kernel code. Example: `__f_schedule_task` |

---

## Postfixes

| Postfix  | Usage               | Description                     |
| -------- | ------------------- | -------------------------------|
| `_t`     | Types               | Used for typedefs or type aliases. Example: `cpu_state_t` |
| `_s`     | Structs             | Used for struct names. Example: `process_s` |
| `_e`     | Enums               | Used for enum types. Example: `error_code_e` |

---

## Naming Conventions

| Pattern | Usage | Description |
| ------- | ----- | ----------- |
| `_XXX_H` | Headers Include | Used for include guards in header files (`.h`). Example: `_POWER_H` |
| `XXXXXX` | C Defined Macros    | Used for macros defined in C files / header (`.c`, `.h`). Example: `WRITE_MSR` |

---

Following these conventions helps maintain readability and clarity across the hypervisor and OS codebases, aiding collaboration and maintenance.

