#!/bin/bash

if [ $(make git-check-if-branch-name-is-correct) == false ]; then
  tput setaf 202
  printf "\n\n  $(echo $0 | sed "s;$PWD/;;"): Branch name '$(git symbolic-ref --short HEAD 2> /dev/null ||:)' does not meet the accepted convention\n\n"
  make show-configuration | grep GIT_BRANCH_PATTERN
  tput sgr0
  exit 1
fi

exit 0
