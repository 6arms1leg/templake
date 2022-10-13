# Sub-Makefile (included by main Makefile)

# Build + run unit tests on host platform
HELP += tests
.PHONY: tests
tests:
	@echo "$(PROMPT)  Build + run unit tests"
# Comment in; only commented out to demonstrate template
	#@ut-tool --run-tests

# Build + run unit tests on host platform with coverage
HELP += tests-cov
.PHONY: tests-cov
tests-cov:
	@echo "$(PROMPT)  Build + run unit tests"
# Comment in; only commented out to demonstrate template
	#@ut-tool --run-tests --coverage

# Cleanup
HELP += clean-tests
.PHONY: clean-tests
clean-tests:
# Comment in; only commented out to demonstrate template
	#ut-tool --clean
	@echo "$(PROMPT)  All cleaned up"
