# Main Makefile (includes sub-Makefiles)

# Build *directory* root path
ROOT_BUILD_PATH := build

# Required for proper exit codes (on continuous integration systems) due to use
# of `tee`
SHELL := /bin/bash -o pipefail

# Do not keep target files of recipes that failed
.DELETE_ON_ERROR:

# Prompt shown with each printed message
PROMPT := Make:

# Help (default target)
.DEFAULT_GOAL := help
HELP += help
.PHONY: help
help:
	@echo "$(PROMPT)  [HELP] Available targets:"
	@echo "$(PROMPT)  [HELP] $(sort $(HELP))"
	@echo "$(PROMPT)  [HELP] Available build types (via variable \`t\`):"
	@echo "$(PROMPT)  [HELP] $(sort $(VAR_PTS))"

# Insert all sub-Makefiles
include make/*.mk

# Cleanup all
HELP += clean-all
.PHONY: clean-all
clean-all:
	rm -rf $(ROOT_BUILD_PATH)/*
	@echo "$(PROMPT)  All cleaned up"
	@touch $(ROOT_BUILD_PATH)/.gitkeep # Remove; only used for template repository
