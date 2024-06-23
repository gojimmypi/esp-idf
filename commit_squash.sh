#!/bin/bash
#
# this assumes there's already an upstream configured:
# git remote add upstream https://github.com/user/upstream_repo.git
#
# also assumes the main branch is still called the legacy "master"
#
# git clone https://github.com/gojimmypi/wolfssl.git wolfssl_configcheck_test --depth 1 --branch ConfigCheck


set -e

echo $0
echo "git status"
git status

echo ""
git remote -v

echo ""
echo "Ready to update $(git branch --show-current) from $(git remote get-url origin)"
echo ""

#**************************************************************************************************
# Confirm we actually want to proceed to publish if there were missing example source files.
#**************************************************************************************************
REFRESH_CONTINUE=
until [ "${REFRESH_CONTINUE^}" == "Y" ] || [ "${REFRESH_CONTINUE^}" == "N" ]; do
    read -r -n1 -p "Proceed? (Y/N) " REFRESH_CONTINUE
    REFRESH_CONTINUE=${REFRESH_CONTINUE^};
    echo;
    sleep 0.5
done

if [ "${REFRESH_CONTINUE}" == "Y" ]; then
    echo "Continuing with refresh..."
else
    echo "Exiting..."
    exit 1
fi

echo""
echo "Enter a password for gpg as needed, otherwise git signing may kick an error..."
gpg -o /dev/null --status-fd=2 -bsau 305148B344E8E820  $0


MAIN_BRANCH=master
BRANCH_TO_SQUASH=$(git branch --show-current)

if [[ "$MAIN_BRANCH" == "$BRANCH_TO_SQUASH" ]]; then
  echo "Cannot squash. Pick a different branch. Currently on $BRANCH_TO_SQUASH "
  exit 1
fi



echo ""
read -p "Ready to fetch upstream $MAIN_BRANCH and squash $BRANCH_TO_SQUASH commits [Y/n] ? " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
  echo "Review each step before proceeding:"
else
  echo "aborted"
  exit 1
fi

echo ""
echo "Fetching and updating from upstream $MAIN_BRANCH"
echo ""

# update our fork master
git checkout "$MAIN_BRANCH"
git fetch upstream

retVal=$?
if [ $retVal -ne 0 ]; then
    echo "Error during git fetch upstream."
    exit $retVal
fi

git pull upstream "$MAIN_BRANCH"
git push


echo ""
echo "Fetching upstream and updating branch: $BRANCH_TO_SQUASH"
echo ""

# update our branch to upstream
git checkout "$BRANCH_TO_SQUASH"
git fetch upstream
git pull upstream "$MAIN_BRANCH"

echo ""
read -p "Everything look good and ready to reset ?" -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
  echo "Here we go!"
  git branch --show-current
  echo ""
else
  echo "Aborted. Will not reset."
  exit 1
fi


# if there are any problem, fix
# git commit
# pull upstream "$MAIN_BRANCH"
# git push

# Method 1:
git reset $(git merge-base "$MAIN_BRANCH" $(git branch --show-current))

# Method 2:
# git rebase "$MAIN_BRANCH"
# git checkout "$MAIN_BRANCH"
# git merge --squash "$BRANCH_TO_SQUASH"
# git branch -D -f "$BRANCH_TO_SQUASH"
# git branch "$BRANCH_TO_SQUASH"

echo ""
read -p "Everything look good and ready to push --force ?" -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
  echo "Proceeding to push --force"
else
  echo "Aborted. Force push not completed."
  exit 1
fi
git push --force

echo ""
echo "git status:"
echo ""
git status

echo ""
echo "Done!"

