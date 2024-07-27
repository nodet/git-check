#!/bin/bash -e

mkdir test-gh-6
cd test-gh-6

mkdir orig
cd orig
git init --initial-branch=main
git commit --allow-empty -m "Initial"

cd ..
mkdir wc
cd wc

git init --initial-branch=another
git commit --allow-empty -m "Another initial"

git remote add origin ../orig
git fetch origin
git push origin another

git checkout origin/main
git commit --allow-empty -m "On main"

git check | grep "based on origin/main" || exit 1

exit 0
