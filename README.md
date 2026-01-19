To use this terminal tool, you need to install:
* apktool
* jadx
* apksigner
* zipalign
* zsh
* gum
* adb

To run this command run:

zsh usr/bin/AndroidDecompiler.sh


dpkg-deb --build myapp-deb
sudo dpkg -i myapp-deb.deb
sudo apt --fix-broken install
sudo apt remove myapp
