#include "Singularity/kernel/kernel.h"
#include "Singularity/common/types.h"

void kmain() {
    asm ("svc 25");
    while (TRUE) { }
}