#!/usr/bin/env zsh


script_dir=$(realpath "$0")
state_dir=$(dirname "$script_dir")

. $state_dir/inApkInstallableState.sh

function inDeviceState {


  echo 
  echo "STATE: inDevice"
  echo 
    


  local options_list=("go back" "search apk file by packageName" "install apk/" "uninstall apk" "disconect" )

  local option=""
  local packageName=""
  local dir_list=()
  local apkFolder=""

  while [[ "$option" != "go back" ]]; do
  
    option=$(gum choose --header="Available device operations > " $options_list)
    gum format -- "selected: $option"

    if [[ "$options_list[2]" == "$option" ]]; then
      packageName=$(gum choose --header="Select packageName of the app > " $(adb shell pm list package | cut -d: -f2))
      [ $? -ne 0 ] && {
        gum format -- "canceled task" ;
        continue ;
      }


      gum format -- "You choose $packageName"

      dir_list=$(gum choose --header="Select all apk you want to get > " --no-limit $(adb shell pm path $packageName | cut -d: -f2))
      [ "$?" -ne 0 ] && {
        gum format -- "canceled task" ;
        continue ;
      }
      
      gum format -- "Pull directory: apk\/"
      
      mkdir apk
      
      [ $? -eq 0 ] || {
        gum format -- "ERROR: Change your actual working directory or delete actual working dir: rm -rf *apk/" ;
        exit ;
      }
      
      for dir_apk in "${dir_list[@]}" ; do
        adb pull "$dir_apk" "apk/"
        gum format -- "Pull $dir_apk"
      done
 

    elif [[ "$options_list[3]" == "$option" ]]; then

      apkFolder=$(gum choose --header="Select apk to install > " $(ls -d *apk/))
      # last command invalid or selected invalid
      ([ "$?" -ne 0 ] || [ "$apkFolder" = "."  ]) && {
        gum format -- "canceled task" ;
        continue ;
      }

      gum format -- "You choose to install apk in $apkFolder"
      adb install-multiple $apkFolder*.apk

    elif [[ "$options_list[4]" == "$option" ]]; then

      packageName=$(gum choose --header="Select apk to uninstall > " $(adb shell pm list package | cut -d: -f2))
      [ "$packageName" = "" ] && { echo "canceled task" ; continue }
      
      gum format -- "You choose to uninstall $packageName"
      adb uninstall "$packageName"
    elif [[ "$options_list[5]" == "$option" ]]; then
    
      adb disconnect
      break
    
    elif [[ "$options_list[1]" != "$option" ]]; then
      gum format -- "Sorry, wrong selection"
    fi
  done


}
