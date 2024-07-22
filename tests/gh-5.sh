#!/bin/bash -e

mkdir test-gh-5
cd test-gh-5

mkdir orig
cd orig
git init --initial-branch=main
git commit --allow-empty -m "Initial"
git checkout -b branch

cd ..
git clone orig wc
cd wc

git config --local check.branches main
git check    | grep "the tip of origin/main"   || exit 1
git check -n | grep "the tip of origin/branch" || exit 1

git config --local check.branches branch
git check    | grep "the tip of origin/branch" || exit 1

exit 0
