# Sub-Makefile (included by main Makefile)

# Compiler/Linker
CC := compiler
LD := linker

# Final binary name (without file type extension)
BIN := app

# Variation points for SW/HW configurations
VAR_PTS := \
    dbg-devBoard \
    dbg-realHw \
    rel-realHw
COMMON_CFLAGS_VAR_PT_DBG := \
    --optimization=off \
    --debug=on \
    --define=DEBUG
ifeq ($(t),dbg-devBoard)
BUILD_PATH_VAR_PT := -$(t)
SRC_PATHS_VAR_PT := vendor/vendor3/bsp-dev-board/source
EXCL_SRC_PATHS_VAR_PT := \
    vendor/vendor3/bsp-dev-board/source/vendor3-module2-unused.c
EXTRA_INCL_PATHS_VAR_PT := vendor/vendor3/bsp-dev-board/include
CFLAGS_VAR_PT := $(COMMON_CFLAGS_VAR_PT_DBG)
endif
ifeq ($(t),dbg-realHw)
BUILD_PATH_VAR_PT := -$(t)
SRC_PATHS_VAR_PT := vendor/vendor3/bsp-real-hw/source
EXCL_SRC_PATHS_VAR_PT := \
    vendor/vendor3/bsp-real-hw/source/vendor3-module4-unused.c
EXTRA_INCL_PATHS_VAR_PT := vendor/vendor3/bsp-real-hw/include
CFLAGS_VAR_PT := $(COMMON_CFLAGS_VAR_PT_DBG)
endif
ifeq ($(t),rel-realHw)
BUILD_PATH_VAR_PT := -$(t)
SRC_PATHS_VAR_PT := vendor/vendor3/bsp-real-hw/source
EXCL_SRC_PATHS_VAR_PT := \
    vendor/vendor3/bsp-real-hw/source/vendor3-module4-unused.c
EXTRA_INCL_PATHS_VAR_PT := vendor/vendor3/bsp-real-hw/include
CFLAGS_VAR_PT := \
    --optimization=max \
    --debug=off
endif

# Build *directory* paths
BUILD_PATH := $(ROOT_BUILD_PATH)/$(BIN)$(BUILD_PATH_VAR_PT)
OBJ_PATH := $(BUILD_PATH)/obj
BIN_PATH := $(BUILD_PATH)/bin

# Paths to source *directories* and single source *files*
SRC_PATHS := \
    lib/lib1 \
    lib/lib2 \
    src \
    vendor/vendor1/source \
    $(SRC_PATHS_VAR_PT)

# Paths to excluded source *directories* and single source *files*
EXCL_SRC_PATHS := \
    lib/lib1/lib1-module2-unused.c \
    lib/lib2/extra1/lib2-module3-unused.c \
    lib/lib2/extra2 \
    $(EXCL_SRC_PATHS_VAR_PT)

# Additional header include *directory* paths not already covered by source paths
#
# Vendor compilers/linkers sometimes ship with extra headers in install
# directory.  If needed, explicitly include their directory path here,
# providing base path and concatenating remaining relative path:
# `$(dir $(shell which $(CC)))>REMAINING RELATIVE PATH<`
EXTRA_INCL_PATHS := \
    vendor/vendor1/include \
    $(EXTRA_INCL_PATHS_VAR_PT)

# Precompiled library *file* paths
#
# Vendor compilers/linkers somethimes ship with extra precompiled libraries in
# install directory.  If needed, explicitly include their paths here, providing
# base path and concatinating remaining relative path:
# `$(dir $(shell which $(LD)))>REMAINING RELATIVE PATH<`
LIB_PATHS := vendor/vendor2/vendor2-lib1.lib

# Linker command *file* path
LINK_CMD_PATH := link.cmd

# Collect all source files to compile/link, remove excluded ones and sort them
SRCS := $(shell find $(SRC_PATHS) -name '*.c' -or -name '*.asm')
EXCL_SRCS := $(shell find $(EXCL_SRC_PATHS) -name '*.c' -or -name '*.asm')
SRCS := $(sort $(filter-out $(EXCL_SRCS),$(SRCS)))

# Prepare object file paths based on source file paths
OBJS := $(SRCS:%=$(OBJ_PATH)/%.o)

# Prepare `*.d` Makefile paths based on object file paths
DEPS := $(OBJS:%.o=%.d)

# Include auto-generated `*.d` Makefiles (by compiler's preprocessor) and
# suppress errors for missing files (not present on initial build)
-include $(DEPS)

# Prepare header include directory paths based on source file paths and
# additional header include directory paths (`sort` removes duplicates)
INCLS := $(sort $(dir $(SRCS)) $(EXTRA_INCL_PATHS))

# Convert header include directory paths to compiler flags
INCL_FLAGS := $(addprefix --include=,$(INCLS))

# Convert precompiled library file paths to linker flags
LIB_FLAGS := $(addprefix --library=,$(LIB_PATHS))

# Compiler flags
COMMON_CFLAGS := \
    --compiler-flag1 \
    --compiler-flag2=... \
    --cpu-cores=$(shell nproc) \
    $(CFLAGS_VAR_PT)
CFLAGS := \
    $(COMMON_CFLAGS) \
    --compiler-flag3
ASMFLAGS := $(COMMON_CFLAGS)

# Linker flags
LDFLAGS := \
    --linker-flag1 \
    --linker-flag2=...

# Sanity check; assert that build type is defined
t ?= no-build-type-defined
SANITY_CHECK = \
    $(if $(shell echo "$(VAR_PTS)" | grep -E "(^|[[:space:]])$(t)([[:space:]]|$$)"), \
    , \
    $(error No/invalid build type provided via variable `t`))

# Final build step: link
HELP += $(BIN)
.PHONY: $(BIN)
$(BIN): LOG_FIL = $@-log.txt
$(BIN): SHA_FIL = $@-checksums.sha1
$(BIN):
	$(SANITY_CHECK)
	@mkdir -p $(BIN_PATH)/
	@$(MAKE) \
	    $(BIN_PATH)/$@1.out \
	    $(BIN_PATH)/$@2.out \
	    2>&1 | tee $(BIN_PATH)/$(LOG_FIL)
	@echo "---" \
	    2>&1 | tee -a $(BIN_PATH)/$(LOG_FIL)
	@echo "Total remarks count: $$(grep -c "Remark\|remark" $(BIN_PATH)/$(LOG_FIL))" \
	    2>&1 | tee -a $(BIN_PATH)/$(LOG_FIL)
	@echo "Total warnings count: $$(grep -c "Warning\|warning" $(BIN_PATH)/$(LOG_FIL))" \
	    2>&1 | tee -a $(BIN_PATH)/$(LOG_FIL)
	@echo "Total errors count: $$(grep -c "Error\|error" $(BIN_PATH)/$(LOG_FIL))" \
	    2>&1 | tee -a $(BIN_PATH)/$(LOG_FIL)
	@cd $(BIN_PATH)/ && \
	    rm -f ./$(SHA_FIL) && \
	    sha1sum ./$@* > ./$(SHA_FIL)
$(BIN_PATH)/$(BIN)1.out: LINK_DEFINE_CONFIG := link-config1
$(BIN_PATH)/$(BIN)2.out: LINK_DEFINE_CONFIG := link-config2
$(BIN_PATH)/$(BIN)%.out: $(OBJS)
	@mkdir -p $(dir $@)
	@echo "$(PROMPT)  [LD] $@"
# Comment in; only commented out to demonstrate template
	#@$(LD) \
	#    $(LDFLAGS) \
	#    --define=LINK_DEFINE=$(LINK_DEFINE_CONFIG) \
	#    $(LIB_FLAGS) \
	#    --link-cmd=$(LINK_CMD_PATH) \
	#    --map=$(@:%.out=%.map) \
	#    --link-info=$(@:%.out=%-link.nfo) \
	#    --output=$@ \
	#    $^
# Remove; only used to demonstrate template
	@touch $(@:%.out=%.map)
	@touch $(@:%.out=%-link.nfo)
	@touch $@

# Object file paths are intermediate prerequisites of chained rule but do not
# delete them
.SECONDARY: $(OBJS)

# Build step for each C source file: compile
$(OBJ_PATH)/%.c.o: %.c
	@mkdir -p $(dir $@)
	@echo "$(PROMPT)  [CC] $< -> $@"
# Comment in; only commented out to demonstrate template
	#@$(CC) \
	#    $(CFLAGS) \
	#    $(INCL_FLAGS) \
	#    --gen-preproc-deps \
	#    --keep-asm \
	#    --output=$@ \
	#    $<
# Remove; only used to demonstrate template
	@touch $(@:%.o=%.d)
	@touch $(@:%.o=%.asm)
	@touch $@

# Build step for each ASM source file
$(OBJ_PATH)/%.asm.o: %.asm
	@mkdir -p $(dir $@)
	@echo "$(PROMPT)  [ASM] $< -> $@"
# Comment in; only commented out to demonstrate template
	#@$(CC) \
	#    $(ASMFLAGS) \
	#    --output=$@ \
	#    $<
	@touch $@ # Remove; only used to demonstrate template

# Cleanup
HELP += clean-$(BIN)
.PHONY: clean-$(BIN)
clean-$(BIN):
	$(SANITY_CHECK)
	rm -rf $(BUILD_PATH)/*
	@echo "$(PROMPT)  All cleaned up"
