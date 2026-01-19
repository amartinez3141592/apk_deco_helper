#!/bin/zsh
. state/inDeviceState.sh

function initState {
  echo
  echo "STATE: Disconnected"
  echo

  local options_list=("Exit" "adb pair & connect" "Go to all apk instalable" "-" "TODO: Create Android Template" "Next")

  local option=""

  while [[ "$option" != "Exit" ]]; do


    option=$(gum choose $options_list)
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
        echo "ERROR > "$(adb shell 2&>1)

    elif [[ "$options_list[3]" == "$option" ]]; then

      apkFolder=$(gum choose --header="Select which apk do you want to decompile > " $(ls -d *apk/ *apkz/ *apku/))
      inApkInstallableState $apkFolder



    elif [[ "$options_list[1]" != "$option" ]]; then
      gum format --  "Sorry, wrong selection"
      
    fi
  done
}
