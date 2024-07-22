#!/bin/bash -e

mkdir test-gh-3
cd test-gh-3

mkdir orig
cd orig
git init --initial-branch=b
git commit --allow-empty -m "Initial"
git commit --allow-empty -m "l"
git tag l
git commit --allow-empty -m "on b after l"
git checkout l
git checkout -b a
git commit --allow-empty -m "on a after l"
git checkout l
git checkout -b c
git commit --allow-empty -m "on c after l"
git checkout a
git merge b -m "Merging b on a"
git checkout c
git merge b -m "Merging b on c"

cd ..
git clone orig wc
cd wc
git checkout l
git branch branch
git commit --allow-empty -m "on branch"
git check | grep "based on origin/b" || exit 1

exit 0
