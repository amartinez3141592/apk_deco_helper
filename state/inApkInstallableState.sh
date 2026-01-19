#!/bin/zsh

function inApkInstallableState {

  echo
  echo "STATE:  inApkInstalableState"
  echo

  local path="$1"
  local options_list=("go back" "Decompile using apktool" "Decompile using jadx")

  local option=""
  local choosedApk=""

  while [[ "$option" != "Exit" ]]; do
  

    option=$(gum choose $options_list)
  
    echo "selected: $option"


    if [[ "$options_list[1]" == "$option" ]]; then
      break


    elif [[ "$options_list[2]" == "$option" ]]; then

      #TODO: verify
      choosedApk=$(gum choose --header="Select apk to decompile" $(ls "$path"/*.apk))


      gum format -- "apk: $choosedApk"
      gum confirm -- "This operation may delete files inside $path-smali/, are you sure? > " && {
        rm -rf "$path-smali/"
        mkdir "$path-smali/"
        gum confirm -- "Decompile resources (is not recommended for splits) > " && 
          apktool d "$choosedApk" -o "$path-smali/" -advance || \
          apktool d "$choosedApk" -o "$path-smali/" -advance --no-res ;
        gum confirm -- "Do you want to use git in this decompilation? (recommended)" && {
          cd "$path-smali"
          git init
          git add *
          git commit -m "init"
          cd ..

        }
      }

    elif [[ "$options_list[3]" == "$option" ]]; then
      #TODO: verify
      choosedApk=$(gum choose --header="Select apk to decompile" $(ls $path/*.apk))
      jadx -e -d "$path-jadx" "$choosedApk" --show-bad-code --log-level ERROR --threads-count 1

    elif [[ "$options_list[1]" != "$option" ]]; then
      echo "Sorry, wrong selection"
    fi
  done
}
