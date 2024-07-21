#!/bin/bash -e

mkdir test-gh-4
cd test-gh-4

mkdir orig
cd orig
git init --initial-branch=main
git commit --allow-empty -m "Initial"
git checkout -b branch
git commit --allow-empty -m "A"

git checkout main
git merge branch -m "Merging branch on main"

git commit --allow-empty -m "B"
git tag B
git commit --allow-empty -m "After B on main"

cd ..
git clone orig wc
cd wc
git checkout B
git commit --allow-empty -m "Diverging from main/B"

git check | grep "based on origin/main"

exit 0
