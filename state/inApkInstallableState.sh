#!/bin/bash

function inApkInstallableState {

  echo
  echo "STATE:  inApkInstalableState"
  echo

  IFS=":"

  local options_list="go back:Decompile using apktool:Decompile using jadx"

  select selected_option_indevice in $options_list; do

    echo "selected: $selected_option_indevice"

    if [[ "$(echo "$options_list" | cut -d: -f1)" == "$selected_option_indevice" ]]; then
      break

    elif [[ "$(echo "$options_list" | cut -d: -f2)" == "$selected_option_indevice" ]]; then

    elif [[ "$(echo "$options_list" | cut -d: -f3)" == "$selected_option_indevice" ]]; then

      echo "selected: $selected_option_indevice"

    else

      echo "Sorry, wrong selection"

    fi
  done
}
