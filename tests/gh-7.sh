#!/bin/bash -e

mkdir test-gh-7
cd test-gh-7

# Create an 'origin'
# Create an 'other' repo
# Clone origin into a working copy
# Push from the wc into other
# Configure the branch to push to other
# Check 'git check' finds other/main

mkdir orig
cd orig
git init --initial-branch=main
git commit --allow-empty -m "Initial"
cd ..

mkdir other
cd other
git init --bare --initial-branch=main
cd ..

git clone orig wc
cd wc
git remote add other ../other
git push other main

git branch --set-upstream-to other/main

git check | grep "the tip of other/main" || exit 1

echo "Test executed successfully"
exit 0
