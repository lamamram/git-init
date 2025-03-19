#!/bin/bash

NEW_ROOT_COMMIT=$1
BRANCH_TO_CUT=$2

git checkout --orphan tmp_branch $NEW_ROOT_COMMIT
## for this new branch almost everything new
git add . && git commit -m "root-commit"
# get the new commits
git merge --ff $2
## WARNING : BACKUP !!!
git branch -D $2
## renaming the new branch with the same name of the cut branch
git branch -m $2
## overwrite remote history
git push -f origin $2
## DESTROY git objects that has no link with the new branch
git gc --aggressive --prune=all
## even for the reflog
git reflog expire --all --expire=now
## THAT'S FOLKS !!!
