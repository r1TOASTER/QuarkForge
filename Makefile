# Names and Defines #
HV = Quanta-HV
OS = Singularity-OS

# Toolchain #
AS = aarch64-none-elf-as
LD = aarch64-none-elf-ld
CC = aarch64-none-elf-gcc
OBJCOPY = aarch64-none-elf-objcopy

# Flags #
CC_FLAGS = -march=armv8-a -mcpu=cortex-a53 -mfix-cortex-a53-843419
CC_FLAGS += -Wall -Wextra -pedantic-errors -g
LD_FLAGS = -T linker.ld -nostdlib -static --gc-sections
OBJCOPY_FLAGS = -O binary

# Sources lists #
HV_C_SRCS = $(shell find $(HV) -name '*.c')
HV_ASM_SRCS = $(shell find $(HV) -name '*.S')
#
OS_C_SRCS = $(shell find $(OS) -name '*.c')
OS_ASM_SRCS = $(shell find $(OS) -name '*.S')

# Includes lists #
HV_INCLUDE_FLAGS := -I$(HV)
OS_INCLUDE_FLAGS := -I$(OS)

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
HV_TARGET = $(HV_BUILD_DIR)/$(HV).bin
OS_TARGET = $(OS_BUILD_DIR)/$(OS).bin

# Images #
HV_IMG = $(HV_BUILD_DIR)/$(HV).elf
OS_IMG = $(OS_BUILD_DIR)/$(OS).elf

# create once the HV objects directory #
$(HV_OBJ_DIR):
	mkdir -p $(HV_OBJ_DIR)

# create once the OS objects directory #
$(OS_OBJ_DIR):
	mkdir -p $(OS_OBJ_DIR)

# Assemble .c and .S files into .o (object files - object directory) - HV #
$(foreach pair,$(HV_OBJ_SRC_C), \
  $(eval $(firstword $(subst :, ,$(pair))): $(lastword $(subst :, ,$(pair))) | $(HV_OBJ_DIR) ; \
      $(CC) $(CC_FLAGS) $(HV_INCLUDE_FLAGS) -c $$< -o $$@ ))

$(foreach pair,$(HV_OBJ_SRC_ASM), \
  $(eval $(firstword $(subst :, ,$(pair))): $(lastword $(subst :, ,$(pair))) | $(HV_OBJ_DIR) ; \
      $(CC) $(CC_FLAGS) $(HV_INCLUDE_FLAGS) -c $$< -o $$@ ))

# Assemble .c and .S files into .o (object files - object directory) - OS #
$(foreach pair,$(OS_OBJ_SRC_C), \
  $(eval $(firstword $(subst :, ,$(pair))): $(lastword $(subst :, ,$(pair))) | $(OS_OBJ_DIR) ; \
      $(CC) $(CC_FLAGS) $(OS_INCLUDE_FLAGS) -c $$< -o $$@ ))

$(foreach pair,$(OS_OBJ_SRC_ASM), \
  $(eval $(firstword $(subst :, ,$(pair))): $(lastword $(subst :, ,$(pair))) | $(OS_OBJ_DIR) ; \
      $(CC) $(CC_FLAGS) $(OS_INCLUDE_FLAGS) -c $$< -o $$@ ))

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
	$(LD) $(LD_FLAGS) $(HV_OBJS) -o $(HV_IMG)
	$(OBJCOPY) $(OBJCOPY_FLAGS) $(HV_IMG) $(HV_TARGET)
	@echo "\nFinished Quanta Hypervisor Build\n"

# Build OS free-standing #
.PHONY: os
os: $(OS_OBJS)
	$(LD) $(LD_FLAGS) $(OS_OBJS) -o $(OS_IMG)
	$(OBJCOPY) $(OBJCOPY_FLAGS) $(OS_IMG) $(OS_TARGET)
	@echo "\nFinished Singularity Operating System Build\n"
	
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