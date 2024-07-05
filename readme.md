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

## Installation

To install the script, you can use [brew](https://brew.sh) and run:
```
$ brew tap nodet/scripts
$ brew install git-check
```

This will download the latest version of the script, and put it somewhere on
your system.  Usually, it ends up in your path, and `git` can find it.  This
allows you to use the script as a `git` command (`git check` instead of
`git-check`).

If you're curious about how to go from 'a realease of this repo' to 'available
through brew', take a look
[here](https://github.com/nodet/homebrew-scripts/blob/main/Formula/git-check.rb).


## Usage

```
$ git check -h
Usage: git check [-l command] [ref]
       git check -h
       git check -v

  -h     Show this help message.
  -v     Show version number.
  -l     Command to use to log the commits.
         Defaults to the value of $GIT_CHECK_LOG_CMD, and
         'log --oneline' if that variable is not set.
  ref    Commit to check, defaults to HEAD.

Example: git check aa89ff6

This script was written by Xavier Nodet <xavier.nodet@gmail.com>
and is Unlicensed <http://unlicense.org/>.
```
