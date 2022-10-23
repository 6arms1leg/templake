# Sub-Makefile (included by main Makefile)

# Build *directory* path for unit tests artifacts
TESTS_BUILD_PATH := $(ROOT_BUILD_PATH)/tests

# Build + run unit tests on host platform
HELP += tests~Build_+_run_unit_tests
.PHONY: tests
tests: LOG_FIL := tests-log.txt
tests:
	@mkdir -p $(TESTS_BUILD_PATH)/
	@echo "$(PROMPT)  Build + run unit tests" \
	    2>&1 | tee $(TESTS_BUILD_PATH)/$(LOG_FIL)
# Comment in; only commented out to demonstrate template
	#@ut-tool --run-tests
	#    2>&1 | tee -a $(TESTS_BUILD_PATH)/$(LOG_FIL)

# Build + run unit tests on host platform with coverage
HELP += tests-cov~Build_+_run_unit_tests_with_coverage
.PHONY: tests-cov
tests-cov: LOG_FIL := tests-cov-log.txt
tests-cov:
	@mkdir -p $(TESTS_BUILD_PATH)/
	@echo "$(PROMPT)  Build + run unit tests with coverage" \
	    2>&1 | tee $(TESTS_BUILD_PATH)/$(LOG_FIL)
# Comment in; only commented out to demonstrate template
	#@ut-tool --run-tests --coverage
	#    2>&1 | tee -a $(TESTS_BUILD_PATH)/$(LOG_FIL)

# Cleanup
HELP += clean-tests~Clean_up_target
.PHONY: clean-tests
clean-tests:
	rm -rf $(TESTS_BUILD_PATH)/* # Or e.g. `ut-tool --clean`
	@echo "$(PROMPT)  All cleaned up"
