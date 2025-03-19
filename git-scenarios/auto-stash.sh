#!/bin/bash

check_index(){
  git stash list | grep -Po "\K[0-9]+\}.+tmp-stash-$1$" | awk -F '}' '{ print $1  }'
}

check_current_branch(){
  git branch -v | grep -Po "^\* \K[a-zA-Z0-9_-]+"
}

current_branch=$(check_current_branch)

if [[ -z $(check_index $current_branch) ]]; then
  git stash push -u -q -m "tmp-stash-$current_branch"
fi

new_branch=$1
git switch $new_branch
# permet de se remettre sur la branche précédente !!!
if [[ "$1" == "-" ]]; then
  new_branch=$(check_current_branch)  
fi

index=$(check_index $new_branch)
# s'il y a un stash a restaurer
if [[ ! -z $index ]]; then
  git stash pop -q stash@{$index}
fi