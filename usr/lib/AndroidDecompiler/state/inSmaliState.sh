#!/usr/bin/env zsh

function inSmaliState {

  echo
  echo "STATE:  inSmaliState"
  echo

  local smali_dir="$1"
  smali_dir=${smali_dir:0:-1} # delete "/" from folder in order to simplify code
  local options_list=("go back" "apktool build")


  local option=""
  local choosedApk=""

  while [[ "$option" != "go back" ]]; do

    option=$(gum choose --header="Available smali operations > "  $options_list)
  
    gum format -- "selected: $option"


    if [[ "$options_list[2]" == "$option" ]]; then

      mkdir "$smali_dir-apkzs"
      apktool b "$smali_dir" -r # -r
      rm "$smali_dir-apkzs"/base.apk
      cp "$smali_dir"/dist/base.apk "$smali_dir-apkzs"
 

    elif [[ "$options_list[3]" == "$option" ]]; then

    elif [[ "$options_list[1]" != "$option" ]]; then
      echo "Sorry, wrong selection"
    fi
  done
}
