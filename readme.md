# git-check

A git command to check the current status of a branch with respect to `origin`.

The script finds the first commit reachable from `HEAD` that also appears in any branch on
`origin`.
It then prints one-liners showing the history from that commit to `HEAD`. In
other words, this is a `git log` command that automatically stops when it gets
uninteresting...

Finally, it lists the files modified by these commits.

## Example

```
$ brew tap nodet/scripts
$ brew install git-check
$ git check
HEAD is based on origin/main (b1feb4a):
a90e1fe [#1] Add -l and GIT_CHECK_LOG_CMD              19 hours ago [nodet] (HEAD -> main)
2c19f03 Test for -h                                    19 hours ago [nodet]
bd2178a Some tests                                     19 hours ago [nodet]
9ef6c92 A bit of command-line arguments checking       20 hours ago [nodet]
fa23da0 Author and license id in the code              20 hours ago [nodet]
0bae109 A few more words of introduction               21 hours ago [nodet]
b1feb4a Update readme.md                               22 hours ago [nodet] (origin/main, origin/HEAD)
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

If you're curious about how to go from 'a release from this repo' to
'available through brew', take a look
[here](https://github.com/nodet/homebrew-scripts/blob/main/Formula/git-check.rb).


## Usage

```
$ git check -h
Usage: git check [-d] [-r remote] [-l command] [-n] [ref]
       git check -h
       git check -v

Show the commits between the specified reference (or HEAD) and the
earliest commit that appears on 'origin', whatever remote that branch
is configured to push to, or another specified remote.

  -h     Show this help message.
  -v     Show version number.
  -d     Print debugging messages.
  -r     Consider the specified remote.
  -l     Command to use to log the commits.
         Defaults to the value of $GIT_CHECK_LOG_CMD, and
         'log --oneline' if that variable is not set.
  -n     Ignore 'check.branches.[remote]' filter.
  ref    Commit to start from, defaults to HEAD.

Example: git check aa89ff6

This script was written by Xavier Nodet <xavier.nodet@gmail.com>
and is Unlicensed <http://unlicense.org/>. It is hosted at
https://github.com/nodet/git-check.
```

The script will only ever consider a single remote when searching from which
branch the reference was created.  By default, that remote is `origin`. But if
the branch is configured to push to another repository (by means of the git
configuration value `branch.[branch].remote` being set), then that remote is
used instead.  In any case, specifying the remote on the command line using
the `-r` flag takes precedence.

When a git configuration option `check.branches.[remote]` exists (e.g.
`check.branches.origin`), it is assumed to be a regex that matches the
branches that should be considered when checking against this remote.  All
other branches in that remote will be ignored.  This is intended to speed-up
the script when there are many branches, as each takes around 1/10th of a
second to check.  This can be ignored with the `-n` option.

Example:
```
$ git config --local check.branches.origin "(master)|(v...)"
```

## How does it work?

For example, with this topology:

```
             o--- HEAD
            /
    ---o---1---o--- main
```

the merge base between `HEAD` and `main` is `1`. That's what
`git merge-base main HEAD` will tell you. And `git-check` will  do the same.

Consider now this case, where two branches contain the commit from which the
branch was forked:

```
                 o--- HEAD
                /
    ---o---o---1--- b1
                \
                 o--- b2
```

As `1` is the tip of `b1`, and not the tip of `b2`, `git check` will consider
`HEAD` as being based on `b1`.

But suppose now that the fork commit is not the tip of any branch:

```
                 o--- HEAD
                /
    ---o---o---1---o--- b1
                \
                 o--- b2
```

In this example, there is no reason to prefer `b1` over `b2`, and `git check`
will consider HEAD to be based on whichever branch it sees first (probably the
one that appears first in alphabetic order).

But usually, branches get merged into each other. Let's consider the case of a
release branch `11.0` and a `main` branch.  The release branch was forked from
`main`, and is merged into it whenever it gets new commits. This looks as the
following:

```
         o---o---o---o-------o--- 11.0
        /         \   \       \
    ---o---A---B---o---o---C---o--- main
```

Commits `A`, `B` and `C` only appear on `main`.  This makes it easy for the
script to distinguish which branch is merged into which: the branch with more
commits that don't appear in the other is considered the main branch, the one
that is being merged to.

This allows to decide which branch is considered as having been forked when
the fork commit appears on multiple branches. For example:

```
                               o--- HEAD
                              /
         o---o---o---o-------l---o--- 11.0
        /         \   \       \
    ---o---A---B---o---o---C---o--- main
```

In this case, because some commits of `main` don't appear in `11.0`, the
latter will be favored, and `git check` will tell you that `HEAD` is based on
'l from `11.0`'.

Finally, consider the case of two release branches that are regularly merged one
to the other, and both to main.  This looks like the following:

```
           o---o-------o--- 10.0
          /     \       \
         /   o---o---o---o----------o--- 11.0
        /   /     \       \          \
    ---o---o---o---o---o---o----------o--- main
```

You create a commit from the tip of `11.0`, and then `11.0` gets updated. This
would look like this:

```
           o---o-------A--- 10.0      o--- HEAD
          /     \       \            /
         /   o---o---o---o----------B---o--- 11.0
        /   /     \       \          \   \
    ---o---o---o---o---o---o----------o---o--- main
```

When looking for the 'merge-base' between `HEAD` and any of `10.0`, `11.0`
and `main`, we find respectively `A`, `B` and `B`.  Indeed, `B` belongs to
both `11.0` and `main`, but we know already that `11.0` is preferred as the
base because `main` has commits that don't appear on `11.0`.

But what about `A`?  After all, this is the 'merge base' between `HEAD` and
`10.0`. The simple reason it should be ruled out is that `A` is an ancestor of
`B`.

It's a bit surprising to see that figuring out what branch was forked is not
that obvious...
