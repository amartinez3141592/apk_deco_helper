#!/bin/bash

cat banner.txt

function main {
  echo "STATE: Disconnected"

  IFS=":"

  options_list="adb pair:adb connect:Create Android Template:Next:Exit"
  select option in $options_list; do
    echo "selected: $option"
    if [[ "$(echo "$options_list" | cut -d: -f1)" == "$option" ]]; then
      echo f1

    elif [[ "$(echo "$options_list" | cut -d: -f2)" == "$option" ]]; then

      echo "f2"

    elif [[ "$(echo "$options_list" | cut -d: -f3)" == "$option" ]]; then

      echo "f3"
      whoseon

    elif [[ "$(echo "$options_list" | cut -d: -f4)" == "$option" ]]; then

      echo "f4"
      memusage

    elif [[ "$(echo "$options_list" | cut -d: -f5)" == "$option" ]]; then

      echo "f5"
      break

    else
      echo "Sorry, wrong selection"

    fi
  done
}

main

unset IFS
