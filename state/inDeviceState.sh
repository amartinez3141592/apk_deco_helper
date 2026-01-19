#!/bin/zsh

. state/inApkInstallableState.sh

function inDeviceState {


  echo 
  echo "STATE: inDevice"
  echo 
    


  local options_list=("go back" "search apk file by packageName" "install apk/" "uninstall apk" "disconect" )

  local option=""
  local packageName=""
  local path_list=()
  local apkFolder

  while [[ "$option" != "go back" ]]; do
  
    option=$(gum choose $options_list )

    gum format -- "selected: $option"

    if [[ "$options_list[2]" == "$option" ]]; then
      packageName=$(gum choose $(adb shell pm list package | cut -d: -f2))

      # TODO : Remove that command, in initState there is a similar condition to
      # avoid adb connection fails
      [ "$packageName" = "" ] && {
        gum format -- "emulator error" ;
        adb disconnect ;
        break ;
      }


      gum format -- "You choose $packageName"

      path_list=$(gum choose --header="Select all apk to get:" --no-limit $(adb shell pm path $packageName | cut -d: -f2))

      gum format -- "Pull directory: apk\/"
      
      mkdir apk
      
      [ $? -eq 0 ] || {
        gum format -- "ERROR: Change your actual working directory or delete actual working dir: rm -rf *apk/" ;
        exit ;
      }
      
      for path_apk in "${path_list[@]}" ; do
        adb pull "$path_apk" "apk/"
        gum format -- "Pull $path_apk"
      done
 

    elif [[ "$options_list[3]" == "$option" ]]; then

      apkFolder=$(gum choose --header="Select apk to install" $(ls -d *apk/))
      adb install-multiple $apkFolder*.apk

    elif [[ "$options_list[4]" == "$option" ]]; then

      packageName=$(gum choose $(adb shell pm list package | cut -d: -f2))
      [ "$packageName" = "" ] && { echo "emulator error" ; adb disconnect ; break }
      
      gum format -- "You choose $packageName"
      adb uninstall "$packageName"
    elif [[ "$options_list[5]" == "$option" ]]; then
    
      adb disconnect
    
    elif [[ "$options_list[1]" != "$option" ]]; then
     gum format -- "Sorry, wrong selection"
    fi
  done


}
