#!/usr/bin/env zsh

script_dir=$(realpath "$0")
state_dir=$(dirname "$script_dir")

. $state_dir/inDeviceState.sh
. $state_dir/inApkInstallableState.sh
. $state_dir/inSmaliState.sh

function initState {
  echo
  echo "STATE: Disconnected"
  echo

  local options_list=("Exit" "adb pair & connect" "Go to all apk instalable" "Go to smali" "Generate keyStore.jks" "Create Android Template" "See graph state")

  local option=""

  while [[ "$option" != "Exit" ]]; do


    option=$(gum choose --header="Available operations > " $options_list)
    gum format -- "selected: $option"

    if [[ "$options_list[2]" == "$option" ]]; then

      ip=$(gum input --prompt="Device ip address(default: $(cat host.default) > ")

      if [[ "$ip" == "" ]]; then
        ip=$(cat host.default)
      fi

      gum format -- "Setting IP ADDRESS to: $ip"
      
      p_port=$(gum input --prompt="Pairing port(default: ignore) > ")

      if [[ "$p_port" != "" ]]; then
        gum format -- "Pairing with $ip:$p_port"
        adb pair "$ip:$p_port"
      fi


      c_port=$(gum input --prompt="Connection port(default: ignore) > ")

      if [[ "$c_port" != "" ]]; then
        adb connect "$ip:$c_port"
        echo "$c_port" >c_port.txt

      fi
      [ $(adb devices | wc -l) -ge 3 ] && \
        inDeviceState || \
        echo "ERROR > "$(adb devices)


    elif [[ "$options_list[3]" == "$option" ]]; then
      # N : ignore if there is no match, is NULL_GLOB of zsh

      apkFolder=$(gum choose --header="Select which apk do you want to decompile > " $(ls -d *apk/(N) *apkz/(N) *apks/(N) *apkzs/(N)  ))
      # last command invalid or selected invalid
      ([ "$?" -ne 0 ] || [ "$apkFolder" = "." ]) && {
        gum format -- "canceled task" ;
        continue ;
      }

      echo $apkFolder""
      inApkInstallableState "$apkFolder"


    elif [[ "$options_list[4]" == "$option" ]]; then
      smaliFolder=$(gum choose --header="Select which smali do you want to choose > " $(ls -d *smali/(N) ))
      
      # last command invalid or selected invalid
      ([ "$?" -ne 0 ] || [ "$apkFolder" = "."  ] ) && {
        gum format -- "canceled task" ;
        continue ;
      }

      inSmaliState "$smaliFolder"


    elif [[ "$options_list[5]" == "$option" ]]; then
      

      keystoreFilename=$(gum input --prompt="Keystore filname(default: keyStore.jks) > ")
      
      if [[ "$keystoreFilename" == "" ]]; then
        keystoreFilename="keyStore.jks"
      fi
 
      myalias=$(gum input --prompt="Alias (default: myalias) > ")
      

      if [[ "$myalias" == "" ]]; then
        myalias="myalias"
      fi

      keytool -genkeypair \
        -keystore "$keystoreFilename" \
        -alias "$myalias" \
        -keyalg RSA \
        -keysize 2048 \
        -validity 10000

    elif [[ "$options_list[6]" == "$option" ]]; then
      echo "Visit that repository https://github.com/android/architecture-templates.git"

      gum confirm -- "This operation may download, are you sure you want to continue? > " && \
        git clone https://github.com/android/architecture-templates.git --branch base androidTemplate

    elif [[ "$options_list[7]" == "$option" ]]; then
      cat $state_dir/graphState.txt
    elif [[ "$options_list[1]" != "$option" ]]; then
      gum format --  "Sorry, wrong selection"
      
    fi
  done
}
