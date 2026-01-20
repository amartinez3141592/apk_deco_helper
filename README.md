#apk_deco_helper

Reverse engineering apk decompiler CLI helper

To use this terminal tool, you need to install:

* apktool
* jadx
* apksigner
* zipalign
* zsh
* gum
* adb


To install from source >


dpkg-deb --build ApkDecoHelper

sudo dpkg -i ApkDecoHelper.deb

sudo apt --fix-broken install

To use it >

apk_deco_helper


To remove it >

sudo apt remove ApkDecoHelper
