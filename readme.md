# git-check

A git command to check the current status of a branch with respect to `origin`.

The script finds the first commit reachable from `HEAD` (by default, could be
any commit/tag/branch) that also appears in any branch on `origin`. It then
prints one-liners showing the history from that commit to `HEAD`. Finally, it
lists the files modified by these commits.

## Example

```
$ brew tap nodet/scripts
$ brew install git-check
$ git check
HEAD is based on origin/main (b1feb4a):
346f1f7 (HEAD -> main) Add -l and GIT_CHECK_LOG_CMD
2c19f03 Test for -h
bd2178a Some tests
9ef6c92 A bit of command-line arguments checking
fa23da0 Author and license id in the code
0bae109 A few more words of introduction
b1feb4a (origin/main, origin/HEAD) Update readme.md
Modified files:
A       Makefile
M       git-check
M       readme.md
```

## Usage

```
$ git check -h
Usage: git check [-h] [-l command] [ref]

  -h     Show this help message
  -l     Command to use to log the commits.
         Defaults to $GIT_CHECK_LOG_CMD, and
         'log --oneline' if that variable is not set
  ref    Commit to check, defaults to HEAD

Example: git check aa89ff6

This script was written by Xavier Nodet <xavier.nodet@gmail.com>
and is Unlicensed <http://unlicense.org/>
```
