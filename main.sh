#!/bin/bash
. state/initState.sh

cat banner.txt

function main {
  initState
}

main

unset IFS
