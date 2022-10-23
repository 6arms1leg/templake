# Sub-Makefile (included by main Makefile)

# Build *directory* path for documentation generation log + artifacts
DOC_BUILD_PATH := $(ROOT_BUILD_PATH)/doc

# Build *directory* path for checksums documentation generation artifacts
CKSUMS_BUILD_PATH := $(ROOT_BUILD_PATH)/sha1sums

# Generate documentation
HELP += doc~Generate_documentation
.PHONY: doc
doc: OUT_DIR := $(DOC_BUILD_PATH)/out
doc: LOG_FIL := doc-log.txt
doc:
	@mkdir -p $(DOC_BUILD_PATH)/
	@echo "$(PROMPT)  Generate documentation" \
	    2>&1 | tee $(DOC_BUILD_PATH)/$(LOG_FIL)
# Comment in; only commented out to demonstrate template
	#@doc-tool \
	#    --output $(OUT_DIR)/ \
	#    2>&1 | tee -a $(DOC_BUILD_PATH)/$(LOG_FIL)
	@mkdir -p $(OUT_DIR)/ # Remove; only used to demonstrate template

# Cleanup
HELP += clean-doc~Clean_up_target
.PHONY: clean-doc
clean-doc:
	rm -rf $(DOC_BUILD_PATH)/*
	@echo "$(PROMPT)  All cleaned up"

# Generate file checksums
HELP += checksums~Generate_file_checksums
.PHONY: checksums
checksums: OUT_FIL := checksums.sha1
checksums: LOG_FIL := checksums-log.txt
checksums:
	@mkdir -p $(CKSUMS_BUILD_PATH)/
	@echo "$(PROMPT)  Generate checksums" \
	    2>&1 | tee $(CKSUMS_BUILD_PATH)/$(LOG_FIL)
	@find \
	    . \
	    -type d \( \
	        -name .git -o \
	        -path "./$(ROOT_BUILD_PATH)*" \
	        \) -prune -o \
	    -type f -exec sha1sum {} + \
	    2>&1 | tee \
	        $(CKSUMS_BUILD_PATH)/$(OUT_FIL) \
	        -a $(CKSUMS_BUILD_PATH)/$(LOG_FIL)

# Cleanup
HELP += clean-checksums~Clean_up_target
.PHONY: clean-checksums
clean-checksums:
	rm -rf $(CKSUMS_BUILD_PATH)/*
	@echo "$(PROMPT)  All cleaned up"
