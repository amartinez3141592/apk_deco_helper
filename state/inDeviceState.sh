#!/bin/bash

. state/inApkInstallableState.sh

function inDeviceState {

  echo
  echo "STATE: inDevice"
  echo

  IFS=":"

  local options_list="go back:search apk file by packageName:next"

  select selected_option_indevice in $options_list; do
    echo "selected: $selected_option_indevice"

    if [[ "$(echo "$options_list" | cut -d: -f1)" == "$selected_option_indevice" ]]; then
      adb disconnect
      break
    elif [[ "$(echo "$options_list" | cut -d: -f2)" == "$selected_option_indevice" ]]; then

      unset IFS
      packageName=$(gum choose --height 10 $(adb shell pm list package | cut -d: -f2))

      echo "You choose $packageName"
      path_list=$(gum choose --header="Select all apk to get:" --no-limit $(adb shell pm path $packageName | cut -d: -f2))

      echo "Pull directory: apk/"
      mkdir apk

      for path in $path_list; do
        adb pull $path apk/
        echo "Pull $path"
      done

      IFS=":"

    elif [[ "$(echo "$options_list" | cut -d: -f3)" == "$selected_option_indevice" ]]; then
      echo TODD
      apkFolder=$(gum choose $(ls -d *apk/))
      inApkInstallableState
      #      adb install-multiple $apkFolder*.apk
    else
      echo "Sorry, wrong selection"

    fi
  done
}
