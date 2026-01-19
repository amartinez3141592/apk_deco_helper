#!/usr/bin/env zsh

cd usr/lib/AndroidDecompiler
. state/initState.sh
cat banner.txt
cd ../../..

function main {
  initState
}
main

# shellcheck  -e SC1091 main.sh
# zsh
