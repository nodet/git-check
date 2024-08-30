#!/bin/bash -e

mkdir test-gh-9
cd test-gh-9

# Create an 'origin'
# With two branches 'main' and 'other', each with one commit
# Clone origin into a working copy, checking out main
# Check that 'git check other' lists the commit in other, not main

mkdir orig
cd orig
git init --initial-branch=main
git commit --allow-empty -m "Initial"
git branch other
git commit --allow-empty -m "On main"
git checkout other
git commit --allow-empty -m "On other"
cd ..

git clone --branch main orig wc
cd wc

git check origin/other | grep "On other" || exit 1

echo "Test executed successfully"
exit 0
