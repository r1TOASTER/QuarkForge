# Names and Defines #
HV = Quanta-HV
OS = Singularity-OS

# Toolchain #
AS = aarch64-none-elf-as
LD = aarch64-none-elf-ld
CC = aarch64-none-elf-gcc
OBJCOPY = aarch64-none-elf-objcopy

# Flags #
# TODO: use -mgeneral-regs-only where not using float points / SIMD
CC_FLAGS = -march=armv8-a+simd -mcpu=cortex-a53 -mfix-cortex-a53-843419 -ffreestanding -nostdlib -mgeneral-regs-only
CC_FLAGS += -Wall -Wextra -pedantic-errors -g -std=c23 -fshort-enums
LD_FLAGS = -nostdlib -static --gc-sections -T linker.ld -L/opt/aarch64-none-elf-toolchain/lib/gcc/aarch64-none-elf/14.3.1
OBJCOPY_FLAGS = --strip-debug -O binary

# Sources lists #
HV_C_SRCS = $(shell find $(HV) -name '*.c')
HV_ASM_SRCS = $(shell find $(HV) -name '*.S')
#
OS_C_SRCS = $(shell find $(OS) -name '*.c')
OS_ASM_SRCS = $(shell find $(OS) -name '*.S')

# Includes lists #
HV_INCLUDE_FLAGS := -I$(HV)/include
OS_INCLUDE_FLAGS := -I$(OS)/include

# Build #
BUILD_DIR = Build
HV_BUILD_DIR = $(BUILD_DIR)/$(HV)
OS_BUILD_DIR = $(BUILD_DIR)/$(OS)

# Obj dirs #
HV_OBJ_DIR := $(HV_BUILD_DIR)/Objects
OS_OBJ_DIR := $(OS_BUILD_DIR)/Objects

# Objects lists #
HV_OBJS := $(addprefix $(HV_OBJ_DIR)/,$(notdir $(HV_C_SRCS:.c=.o)))
HV_OBJS += $(addprefix $(HV_OBJ_DIR)/,$(notdir $(HV_ASM_SRCS:.S=.o)))
#
OS_OBJS := $(addprefix $(OS_OBJ_DIR)/,$(notdir $(OS_C_SRCS:.c=.o)))
OS_OBJS += $(addprefix $(OS_OBJ_DIR)/,$(notdir $(OS_ASM_SRCS:.S=.o)))

# Mapping objs to sources #
HV_OBJ_SRC_C = $(foreach src,$(HV_C_SRCS),$(OS_OBJ_DIR)/$(notdir $(src:.c=.o)):$(src))
HV_OBJ_SRC_ASM = $(foreach src,$(HV_ASM_SRCS),$(OS_OBJ_DIR)/$(notdir $(src:.S=.o)):$(src))
#
OS_OBJ_SRC_C = $(foreach src,$(OS_C_SRCS),$(OS_OBJ_DIR)/$(notdir $(src:.c=.o)):$(src))
OS_OBJ_SRC_ASM = $(foreach src,$(OS_ASM_SRCS),$(OS_OBJ_DIR)/$(notdir $(src:.S=.o)):$(src))

# Targets #
HV_TARGET = $(HV_BUILD_DIR)/$(HV).img
OS_TARGET = $(OS_BUILD_DIR)/$(OS).img

# Images #
HV_ELF = $(HV_BUILD_DIR)/$(HV).elf
OS_ELF = $(OS_BUILD_DIR)/$(OS).elf

# Qemu #
QEMU = qemu-system-aarch64
PORT = 9999

# create once the HV objects directory #
$(HV_OBJ_DIR):
	mkdir -p $(HV_OBJ_DIR)

# create once the OS objects directory #
$(OS_OBJ_DIR):
	mkdir -p $(OS_OBJ_DIR)

# Assemble .c and .S files into .o (object files - object directory) - HV #
$(foreach pair,$(HV_OBJ_SRC_C), \
  $(eval $(firstword $(subst :, ,$(pair))): $(lastword $(subst :, ,$(pair))) | $(HV_OBJ_DIR) ; \
      $(CC) $(HV_INCLUDE_FLAGS) $(CC_FLAGS) -c $$< -o $$@ ))

$(foreach pair,$(HV_OBJ_SRC_ASM), \
  $(eval $(firstword $(subst :, ,$(pair))): $(lastword $(subst :, ,$(pair))) | $(HV_OBJ_DIR) ; \
      $(CC) $(HV_INCLUDE_FLAGS) $(CC_FLAGS) -c $$< -o $$@ ))

# Assemble .c and .S files into .o (object files - object directory) - OS #
$(foreach pair,$(OS_OBJ_SRC_C), \
  $(eval $(firstword $(subst :, ,$(pair))): $(lastword $(subst :, ,$(pair))) | $(OS_OBJ_DIR) ; \
      $(CC) $(OS_INCLUDE_FLAGS) $(CC_FLAGS) -c $$< -o $$@ ))

$(foreach pair,$(OS_OBJ_SRC_ASM), \
  $(eval $(firstword $(subst :, ,$(pair))): $(lastword $(subst :, ,$(pair))) | $(OS_OBJ_DIR) ; \
      $(CC) $(OS_INCLUDE_FLAGS) $(CC_FLAGS) -c $$< -o $$@ ))

# Build HV and OS #
.PHONY: all
all:
	@echo "\nTrying to Build Quanta Hypervisor\n"
	-$(MAKE) hv

	@echo "\nTrying to Build Singularity Operating System\n"
	-$(MAKE) os

# Build HV free-standing #
.PHONY: hv
hv: $(HV_OBJS)
	$(LD) $(LD_FLAGS) $(HV_OBJS) -lgcc -o $(HV_ELF)
	$(OBJCOPY) $(OBJCOPY_FLAGS) $(HV_ELF) $(HV_TARGET)
	@echo "\nFinished Quanta Hypervisor Build\n"

# Build OS free-standing #
.PHONY: os
os: $(OS_OBJS)
	$(LD) $(LD_FLAGS) $(OS_OBJS) -lgcc -o $(OS_ELF)
	$(OBJCOPY) $(OBJCOPY_FLAGS) $(OS_ELF) $(OS_TARGET)
	@echo "\nFinished Singularity Operating System Build\n"

# Running OS on Qemu for AArch64 - using the raspi3b machine guest
.PHONY: os-run
os-run: os
	$(QEMU) -M raspi3b \
	-kernel $(OS_TARGET) \
	-semihosting-config enable=on,target=native \
	-serial none -serial mon:stdio \
	-display none \
	-cpu cortex-a53 \
	-S -gdb tcp::$(PORT)
	
# Running HV on Qemu for AArch64 - using the raspi3b machine guest
# TODO: because it's HV, maybe use -deviice loader,addr=0x80000 (or where raspi actually start the boot stub), cpu-num=0?
.PHONY: hv-run
hv-run: hv
	$(QEMU) -M raspi3b \
	-kernel $(HV_TARGET) \
	-semihosting-config enable=on,target=native \
	-serial none -serial mon:stdio \
	-display none \
	-cpu cortex-a53 \
	-S -gdb tcp::$(PORT)

# Clean the entire build #
.PHONY: clean
clean:
	$(RM) -rf $(BUILD_DIR)/*

# Clean only HV build #
.PHONY: clean-hv
clean-hv:
	$(RM) -rf $(HV_BUILD_DIR)/*

# Clean only OS build #
.PHONY: clean-os
clean-os:
	$(RM) -rf $(OS_BUILD_DIR)/*