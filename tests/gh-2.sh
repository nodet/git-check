#!/bin/bash -e

mkdir test-gh-2
cd test-gh-2

mkdir orig
cd orig
git init --initial-branch=b
git commit --allow-empty -m "Initial"

cd ..
git clone orig rem
git clone orig wc
cd wc

git remote add rem ../rem
git checkout -b new_branch origin/b
git commit --allow-empty -m "on new_branch"
git push rem new_branch

git commit --allow-empty -m "another new_branch"

git check -r rem | grep "based on rem/new_branch" || exit 1

echo "Test executed successfully"
exit 0
