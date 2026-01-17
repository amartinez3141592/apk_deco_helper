#!/bin/bash
. state/inDeviceState.sh

function initState {

  echo "STATE: Disconnected"

  IFS=":"

  local options_list="Exit:adb pair & connect:Create Android Template:Next"
  select option in $options_list; do
    echo "selected: $option"

    if [[ "$(echo "$options_list" | cut -d: -f1)" == "$option" ]]; then

      break

    elif [[ "$(echo "$options_list" | cut -d: -f2)" == "$option" ]]; then
      echo -n "Ip address(default: $(cat localhost.default)): "
      read ip

      if [[ "$ip" == "" ]]; then
        #ip="192.168.1.33"
        ip=$(cat localhost.default)

        echo "Setting ip to default: $ip"
      fi

      echo -n "Pairing port(default: ignore): "
      read p_port

      if [[ "$p_port" != "" ]]; then
        adb pair $ip:$p_port

        echo "Pairing with $ip:$p_port"

      fi

      echo -n "Connection port(default: ignore): "
      read c_port

      if [[ "$c_port" != "" ]]; then
        adb connect $ip:$c_port

        echo "$c_port" >c_port.txt

        echo "Connecting to $ip:$p_port"
      fi

      inDeviceState
    elif [[ "$(echo "$options_list" | cut -d: -f3)" == "$option" ]]; then
      echo "f2"

    elif [[ "$(echo "$options_list" | cut -d: -f4)" == "$option" ]]; then

      echo "f3"
      whoseon

    else
      echo "Sorry, wrong selection"

    fi
  done
}
