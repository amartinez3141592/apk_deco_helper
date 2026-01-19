#!/usr/bin/env zsh

function inApkInstallableState {

  echo
  echo "STATE:  inApkState"
  echo

  local apk_dir="$1"
  apk_dir=${apk_dir:0:-1} # delete "/" from folder in order to simplify code
  local options_list=("go back" "Decompile using apktool" "Decompile using jadx" "Zipalign APK (might be helpful for apktool d with resources)" "Sign APK (required to install)")

  local option=""
  local choosedApk=""
  apk_dir_out=""

  while [[ "$option" != "go back" ]]; do

    option=$(gum choose --header="Available APK operations" $options_list)
  
    gum format -- "selected: $option"


    if [[ "$options_list[2]" == "$option" ]]; then
      choosedApk=$(gum choose --header="Select apk to decompile with apktool > " $(ls "$apk_dir"/*.apk))
 
      # last command invalid or selected invalid
      ([ "$?" -ne 0 ] || [ "$apkFolder" = "."  ]) && {
        gum format -- "canceled task" ;
        continue ;
      }

      gum format -- "apk: $choosedApk"
      gum confirm -- "This operation may delete files inside $apk_dir-smali/, are you sure? > " && {
        rm -rf "$apk_dir-smali/"
        gum format -- "Removing dir $apk_dir-smali" ;
        
        gum confirm --default="No" -- "Decompile resources (is not recommended for splits) > " && 
          apktool d -o "$apk_dir-smali/" -advance "$chooosedApk" || \
          apktool d -o "$apk_dir-smali/" -advance --no-res $choosedApk ;

        gum confirm -- "Do you want to use git in this decompilation? (recommended)" && {
          cd "$apk_dir-smali"
          git init
          git add *
          git commit -m "init"
          cd ..

        }
      }

    elif [[ "$options_list[3]" == "$option" ]]; then

      choosedApk=$(gum choose --header="Select apk to decompile with jadx > " $(ls $apk_dir/*.apk))
      # last command invalid or selected invalid
      ([ "$?" -ne 0 ] || [ "$apkFolder" = "."  ]) && {
        gum format -- "canceled task" ;
        continue ;
      }
      
      jadx -e -d "$apk_dir-jadx" "$choosedApk" --show-bad-code --log-level ERROR --threads-count 1


    elif [[ "$options_list[4]" == "$option" ]]; then
      
      if [ $(echo "$apk_dir" | grep -c apks$) -eq 1 ]; then 
        gum format -- "Unable to zipalign: $apk_dir already zipaligned" 
        continue 
      fi

      if [ $(echo "$apk_dir" | grep -c apkz$) -eq 1 ]; then
        apk_dir_out="${apk_dir:0:-1}"
      fi 
      
      if [ $(echo "$apk_dir" | grep -c apkzs$) -eq 1 ]; then
        apk_dir_out="${apk_dir:0:-2}s"
      fi

      gum format -- "$apk_dir -> $apk_dir_out"
      
      cp -r $apk_dir $apk_dir_out
      
      for f in $apk_dir_out/*.apk; do
        zipalign -p -f -v 4 $f $f.aux
        rm $f
        mv $f.aux $f
      done


    elif [[ "$options_list[5]" == "$option" ]]; then

      if [ $(echo "$apk_dir" | grep -c apks$) -eq 1 ]; then
        apk_dir_out="${apk_dir:0:-1}"
      fi 

      if [ $(echo "$apk_dir" | grep -c apkz$) -eq 1 ]; then
        gum format -- "Unable to sign: $apk_dir already signed"
        continue
      fi
      
      if [ $(echo "$apk_dir" | grep -c apkzs$) -eq 1 ]; then
        apk_dir_out="${apk_dir:0:-2}z"
      fi

      gum format -- "$apk_dir -> $apk_dir_out"

      keystoreFilename=$(gum input --prompt="Keystore filname(default: keyStore.jks) > ")
      [ "$?" -ne 0 ] && {
        gum format -- "canceled task" ;
        continue ;
      }

      if [[ "$keystoreFilename" == "" ]]; then
        keystoreFilename="keyStore.jks"
      fi

      myalias=$(gum input --prompt="Alias (default: myalias) > ")
      [ "$?" -ne 0 ] && {
        gum format -- "canceled task" ;
        continue ;
      }

      if [[ "$myalias" == "" ]]; then
        myalias="myalias"
      fi
      

      cp -r $apk_dir $apk_dir_out
      
      for f in $apk_dir_out/*.apk; do
        gum format -- "SIGN: $f"
        apksigner sign \
          --ks "$keystoreFilename" \
          --ks-key-alias "$myalias" \
          --v1-signing-enabled true \
          --v2-signing-enabled true \
          "$f"
        
        [ "$?" -ne 0 ] && {
          gum format -- "canceled task" ;
          canceledTask="c"
          continue ;
        }
      done
      
      [ -z "$canceledTask" ] || continue 
      canceledTask=""

      for f in $apk_dir_out/*.apk; do
        echo "==== $f ===="
        apksigner verify --print-certs "$f"
      done

    elif [[ "$options_list[1]" != "$option" ]]; then
      echo "Sorry, wrong selection"
    fi
  done
}
