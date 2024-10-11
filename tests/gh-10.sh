#!/bin/bash -e

name=$(basename "$0" .sh)

mkdir test-$name
cd test-$name

# Create an 'origin', to mimick a 'dev' branch situation:
#
# *   95a385a (HEAD -> main) Merging dev on main twice
# |\
# | * 2129646 (origin/dev, dev) On dev #2
# * | 32e8b19 (origin/main, origin/HEAD) Merging dev on main once
# |\|
# | * a6f1704 On dev #1
# * | 7109077 On main
# |/
# * 6e8570d Initial

# check that 'git check main' chooses origin/main as the base branch

mkdir orig
cd orig
git init --initial-branch=main
git commit --allow-empty -m "Initial"
git checkout -b dev
git commit --allow-empty -m "On dev #1"
git checkout main
git commit --allow-empty -m "On main"
git merge dev -m "Merging dev on main once"
cd ..

git clone orig wc
cd wc
git checkout -b dev origin/dev
git commit --allow-empty -m "On dev #2"
git push origin dev
git checkout main
git merge dev -m "Merging dev on main twice"

git check | grep "based on origin/main" || exit 1

echo "Test executed successfully"
exit 0
