# git-check

A git command to check the current status of a branch with respect to `origin`.


## Example

```
$ brew tap nodet/scripts
$ brew install git-check
$ git check
HEAD is based on origin/main (d9d4d46):
2ff09b8 Skeleton of readme                   3 seconds ago [Xavier Nodet] (HEAD -> main)
99fec54 Add UNLICENSE                        48 seconds ago [Xavier Nodet]
d9d4d46 The real code                        34 minutes ago [Xavier Nodet] (origin/main, origin/HEAD)
Modified files:
A       UNLICENSE
A       readme.md
```
