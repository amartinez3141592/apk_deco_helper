#!/bin/zsh

. state/initState.sh

cat banner.txt

function main {
  initState
}
main

# shellcheck  -e SC1091 main.sh
# zsh
