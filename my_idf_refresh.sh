#~/bin/bash

set -e

git checkout master

# Fetch the latest changes from upstream
git fetch upstream

# Ensure you are on the master branch
git checkout master

# Reset the local master branch to match the upstream master branch
git reset --hard upstream/master

# Initialize and update all submodules to their latest commit as per upstream master
git submodule update --init --recursive --remote

# Reset all submodules to the state recorded in the superproject's latest commit
git submodule foreach --recursive 'git reset --hard'

# Update submodule references to match the upstream master
git submodule update --recursive

exit 0


git fetch
git pull
git fetch upstream master
git pull  upstream master

git submodule update --init --recursive


git submodule foreach '
  git fetch origin

  # Determine the default branch (main or master)
  if git show-ref --verify --quiet refs/heads/main; then
    default_branch="main"
  elif git show-ref --verify --quiet refs/heads/master; then
    default_branch="master"
  else
    echo "No main or master branch found in submodule."
    exit 1
  fi

  # Check out the default branch and reset to the latest commit
  git checkout $default_branch
  git reset --hard origin/$default_branch
'

git submodule update --recursive --remote

git submodule foreach --recursive '
  git fetch origin
  git reset --hard HEAD
'
