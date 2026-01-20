#!/usr/bin/env zsh

SCRIPT=$(realpath "$0")
app_dir=$(dirname "$SCRIPT")

. $app_dir/state/initState.sh
cat $app_dir/banner.txt



function main {
  initState
}
main

# shellcheck  -e SC1091 main.sh
# zsh
