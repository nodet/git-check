all: all-tests

clean:
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


test: test-origin test-wc

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
auto-tests: test $(wildcard $(TEST_DIR)/*.sh)
	@for script in $^; do \
		echo "Running $$script"; \
		sh $$script; \
	done

all-tests: test auto-tests
	@echo "All tests executed without error."
