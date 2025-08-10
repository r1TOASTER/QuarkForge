# Names and Defines #
HV = Quanta-HV
OS = Singularity-OS

# Toolchain #
AS = aarch64-none-elf-as
LD = aarch64-none-elf-ld
CC = aarch64-none-elf-gcc
OBJCOPY = aarch64-none-elf-objcopy

# Flags #
CC_FLAGS = -march=armv8-a -mcpu=cortex-a53 -mfpu=neon-fp-armv8 --fix-cortex-a53-843419 -mfloat-abi=hard -mno-red-zone -static -nostdlib -ffreestanding
CC_FLAGS += -Wall -Wextra -g
#
AS_FLAGS = -g
LD_FLAGS = -T linker.ld
OBJCOPY_FLAGS = -O binary

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
HV_OBJS := $(patsubst $(HV)/%.c,$(HV_OBJ_DIR)/%.o,$(HV_C_SRCS))
HV_OBJS += $(patsubst $(HV)/%.S,$(HV_OBJ_DIR)/%.o,$(HV_ASM_SRCS))
#
OS_OBJS := $(patsubst $(OS)/%.c,$(OS_OBJ_DIR)/%.o,$(OS_C_SRCS))
OS_OBJS += $(patsubst $(OS)/%.S,$(OS_OBJ_DIR)/%.o,$(OS_ASM_SRCS))

# Targets #
HV_TARGET = $(HV_BUILD_DIR)/$(HV).bin
OS_TARGET = $(OS_BUILD_DIR)/$(OS).bin

# Images #
HV_IMG = $(HV_BUILD_DIR)/$(HV).elf
OS_IMG = $(OS_BUILD_DIR)/$(OS).elf

# Assemble .c and .S files into .o (object files - object directory) - HV #
$(HV_OBJ_DIR)/%.o: $(HV)/%.c
	@mkdir -p $(dir $@)
	$(CC) $(CC_FLAGS) $(HV_INCLUDE_FLAGS) -c $< -o $@

$(HV_OBJ_DIR)/%.o: $(HV)/%.S
	@mkdir -p $(dir $@)
	$(AS) $(AS_FLAGS) $< -o $@

# Assemble .c and .S files into .o (object files - object directory) - OS #
$(OS_OBJ_DIR)/%.o: $(OS)/%.c
	@mkdir -p $(dir $@)
	$(CC) $(CC_FLAGS) $(OS_INCLUDE_FLAGS) -c $< -o $@

$(OS_OBJ_DIR)/%.o: $(OS)/%.S
	@mkdir -p $(dir $@)
	$(AS) $(AS_FLAGS) $< -o $@

# Build HV and OS #
.PHONY: all
all: $(HV_TARGET) $(OS_TARGET)

# Build HV free-standing #
.PHONY: hv
$(HV_TARGET): $(HV_OBJS)
	$(LD) $(LD_FLAGS) $^ -o $@
	$(OBJCOPY) $(OBJCOPY_FLAGS) $(HV_TARGET) $(HV_IMG)

# Build OS free-standing #
.PHONY: os
$(OS_TARGET): $(OS_OBJS)
	$(LD) $(LD_FLAGS) $^ -o $@
	$(OBJCOPY) $(OBJCOPY_FLAGS) $(OS_TARGET) $(OS_IMG)
	
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