all: all-tests    ## Run all tests and confirm all is good

# Help command courtesy of https://gist.github.com/prwhite/8168133
help:           ## Show this help.
#	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m\033[0m\n"} /^[$$()% a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

clean:          ## Remove build and test artifacts
	rm -rf test-origin
	rm -rf test-wc
	rm -rf test-*

test-origin:
	mkdir test-origin
	cd test-origin; \
	git init --initial-branch=main; \
	git commit --allow-empty -m "An initial commit"; \
	git commit --allow-empty -m "A: on main"; \
	git branch a_branch; \
	git commit --allow-empty -m "B: on main"; \
	git checkout a_branch; \
	git commit --allow-empty -m "C: on a_branch, from A"; \
	git checkout main; \
	git merge a_branch -m "Merging a_branch"

test-wc: test-origin
	git clone test-origin test-wc


test: test-origin test-wc    ## Run 'manually coded' tests

	# Check -h
	git check -h | grep 'Usage'

	# Check -v
	git check -v | grep 'git-check '

	# Check before any change
	cd test-wc; \
		git check | grep 'HEAD is the tip of origin/main'

	# Check a branch created from the tip of a remote branch
	cd test-wc; \
		git checkout -b a_new_branch origin/a_branch; \
		git commit --allow-empty -m "D: on a new branch based on a_branch"; \
		git check | grep 'HEAD is based on origin/a_branch'

	# Check a detached commit
	cd test-wc; \
		git checkout origin/a_branch; \
		git commit --allow-empty -m "E: based on a_branch"; \
		git check | grep 'HEAD is based on origin/a_branch'

	# Check control of the command used to display commits
	# If 'Author' appears, it must be because we successfully replaced
	# the default command with the basic 'log'
	cd test-wc; \
		GIT_CHECK_LOG_CMD= git check | grep -v 'Author'; \
		GIT_CHECK_LOG_CMD= git check -l "log" | grep 'Author'; \
		GIT_CHECK_LOG_CMD="log" git check | grep 'Author'

	# Check a commit already on origin
	cd test-wc; \
		git checkout origin/a_branch^; \
		git check | grep 'HEAD belongs to origin/a_branch'

	# Check a commit already on origin and tip of branch
	cd test-wc; \
		git checkout origin/a_branch; \
		git check | grep 'HEAD is the tip of origin/a_branch'

# Run all the tests in directory 'tests'
TEST_DIR := tests
auto-tests: $(wildcard $(TEST_DIR)/*.sh)   ## Run 'automatically' configured tests
	@for script in $^; do \
		echo "Running $$script"; \
		$$script || exit 1; \
	done

all-tests: test auto-tests
	@echo "All tests executed without error."
