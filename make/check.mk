# Sub-Makefile (included by main Makefile)

# Source *directory* paths to check
CK_SRC_PATHS := \
    lib \
    src \
    vendor

# Build *directory* path for code check log
CK_BUILD_PATH := $(ROOT_BUILD_PATH)/check

# Build *directory* path for ToDo comments locations log
TODO_BUILD_PATH := $(ROOT_BUILD_PATH)/todo

# Check code
HELP += check~Check_code
.PHONY: check
check: LOG_FIL := check-log.txt
check:
	@mkdir -p $(CK_BUILD_PATH)/
	@echo "$(PROMPT)  Check code"
	#@checker \
	#    --input $(CK_SRC_PATHS) \
	#    2>&1 | tee $(CK_BUILD_PATH)/$(LOG_FIL)
	@touch $(CK_BUILD_PATH)/$(LOG_FIL) # Remove; only used to demonstrate template

# Cleanup
HELP += clean-check~Clean_up_target
.PHONY: clean-check
clean-check:
	rm -rf $(CK_BUILD_PATH)/*
	@echo "$(PROMPT)  All cleaned up"

# Find ToDos in code base
HELP += find-todo~Find_ToDos_in_code_base
.PHONY: find-todo
find-todo: OUT_FIL := todo.txt
find-todo: TODO_MARKER := TODO:
find-todo:
	@mkdir -p $(TODO_BUILD_PATH)/
	@echo "$(PROMPT)  Find ToDos in code base"
	@find \
	    . \
	    -type d \( \
	        -name .git -o \
	        -path "./$(ROOT_BUILD_PATH)*" \
	        \) -prune -o \
	    -type f -exec grep -Hn "$(TODO_MARKER)" {} + | \
	    grep -v ":= $(TODO_MARKER)" \
	    2>&1 | tee $(TODO_BUILD_PATH)/$(OUT_FIL) || exit 0
	@echo "---" \
	    2>&1 | tee -a $(TODO_BUILD_PATH)/$(OUT_FIL)
	@echo \
	    "Total TODO comments count: $$(grep -c "$(TODO_MARKER)" $(TODO_BUILD_PATH)/$(OUT_FIL))" \
	    2>&1 | tee -a $(TODO_BUILD_PATH)/$(OUT_FIL)
	@grep -q "$(TODO_MARKER)" $(TODO_BUILD_PATH)/$(OUT_FIL) && \
	    exit 1 || exit 0

# Cleanup
HELP += clean-find-todo~Clean_up_target
.PHONY: clean-find-todo
clean-find-todo:
	rm -rf $(TODO_BUILD_PATH)/*
	@echo "$(PROMPT)  All cleaned up"
