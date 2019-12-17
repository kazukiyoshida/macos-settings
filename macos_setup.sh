#!/bin/sh

sudo -v

#===============================================================================
# macOS Settings
# cf. https://ottan.xyz/system-preferences-terminal-defaults-dock-4644/
# cf. https://qiita.com/djmonta/items/17531dde1e82d9786816
#===============================================================================

echo ">>> macOS settings"

# >>>>>>>>>>>>>>>>>>>>>>>>>>>
# >>> Basics

# WIP: change wallpaper
# WIP: change user image

# ホスト名を設定
COMPUTERNAME=kazuki-macbook
sudo scutil --set ComputerName $COMPUTERNAME
sudo scutil --set HostName $COMPUTERNAME.local
sudo scutil --set LocalHostName $COMPUTERNAME

# ウィンドウを閉じた時のアニメーションを停止
defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false

# コンテンツをタイトルバーの領域まで広げる
defaults write window.titlebarAppearsTransparent true

# スリープやスクリーンセイバーからの復旧時にパスワードを求めるようにする
defaults write com.apple.screensaver askForPassword -int 1 
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Spotlight は使わないので、index を作成しないようにしそれを削除する
# （mds や mds_stores constantly といったプロセスが CPU 大量消費をしなくなる）
sudo mdutil -a -i off
sudo rm -rf /.Spotlight-V100/

# ネットワークディスクで、`.DS_Store` ファイルを作らない
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# スクリーンショット保存形式をPNGにする
defaults write com.apple.screencapture type -string "png"

# タップでクリックを有効にする
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# スクリーンショット保存形式をPNGにする
defaults write com.apple.screencapture type -string "png"

# バッテリー残量の%表記を追加
defaults write com.apple.menuextra.battery ShowPercent -string "YES"

# Bluetooth を切る
sudo defaults write /Library/Preferences/com.apple.Bluetooth ControllerPowerState -int 0


# >>>>>>>>>>>>>>>>>>>>>>>>>>>
# >>> Dock

# アイコンのサイズ、位置、表示/非表示の設定
defaults write com.apple.dock tilesize -int 36
defaults write com.apple.dock largesize -int 36
defaults write com.apple.dock orientation -string "left"
defaults write com.apple.dock autohide -bool true

# ポインタでかざした際に拡大しないようにする
defaults write com.apple.dock magnification -bool false

# ゴミ箱とFinder以外の標準アプリを全て消す
defaults write com.apple.dock persistent-apps -array


# >>>>>>>>>>>>>>>>>>>>>>>>>>>
# >>> Finder

# Path bar を表示
defaults write com.apple.finder ShowPathbar -bool true

# Tab bar を表示
defaults write com.apple.finder ShowTabView -bool true

# ~/Library フォルダを可視化
chflags nohidden ~/Library

# Finder のタイトルをディレクトリ名から絶対パスに変更
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# 不可視ファイルを表示
defaults write com.apple.finder AppleShowAllFiles YES

# 「保存」ダイアログのデフォルトを「詳細設定」にする
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true 

# ディレクトリ名の翻訳ファイルを削除
sudo rm -f /Applications/.localized
sudo rm -f /Applications/Utilities/.localized
sudo rm -f /Users/.localized
sudo rm -f /Users/Shared/.localized
sudo rm -f /Library/.localized
rm -f ~/Applications/.localized
rm -f ~/Desktop/.localized
rm -f ~/Documents/.localized
rm -f ~/Downloads/.localized
rm -f ~/Dropbox/.localized
rm -f ~/Library/.localized
rm -f ~/Movies/.localized
rm -f ~/Music/.localized
rm -f ~/Pictures/.localized
rm -f ~/Public/.localized
rm -f ~/Sites/.localized


# >>>>>>>>>>>>>>>>>>>>>>>>>>>
# >>> Hot Corners
#
# Possible values:
#  0: no-op
#  2: Mission Control
#  3: Show application windows
#  4: Desktop
#  5: Start screen saver
#  6: Disable screen saver
#  7: Dashboard
# 10: Put display to sleep
# 11: Launchpad
# 12: Notification Center

# Top left screen corner → Sleep
defaults write com.apple.dock wvous-tl-corner -int 10
defaults write com.apple.dock wvous-tl-modifier -int 0

# Top right screen corner
#defaults write com.apple.dock wvous-tr-corner -int 0
#defaults write com.apple.dock wvous-tr-modifier -int 0

# Bottom right screen corner 
#defaults write com.apple.dock wvous-br-corner -int 4
#defaults write com.apple.dock wvous-br-modifier -int 0

# Bottom left screen corner → Desktop
defaults write com.apple.dock wvous-bl-corner -int 4
defaults write com.apple.dock wvous-bl-modifier -int 0


#===============================================================================
# Shell
#===============================================================================

echo ">>> Shell settings"

# WIP: change shell to zsh default installed
# WIP: set terminal's theme color Icebarg

#===============================================================================
# Programming Tools
#===============================================================================

echo ">>> Programming tools settings"

#
# Homebrew
#
brew -v &> /dev/null
if [ $? -ne 0 ] ; then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
  echo "homebrew is already installed"
fi

#
# Rust
#
cargo -v &> /dev/null
if [ $? -ne 0 ] ; then
  curl https://sh.rustup.rs -sSf | sh
else
  echo "rust toolchain is already installed"
fi

#
# Node
#
nodebrew -v &> /dev/null
if [ $? -ne 0 ] ; then
  brew install nodebrew
else
  echo "nodebrew is already installed"
fi

node -v &> /dev/null
if [ $? -ne 0 ] ; then
  if [ ! -e ~/.nodebrew/src ]; then
    mkdir -p ~/.nodebrew/src
  fi
  nodebrew install-binary latest
  ln -s ~/.nodebrew/current/bin/node /usr/local/bin/
  ln -s ~/.nodebrew/current/bin/npm /usr/local/bin/
  ln -s ~/.nodebrew/current/bin/npx /usr/local/bin/
else
  echo "node is already installed"
fi

#
# Go
#
goenv -v &> /dev/null
if [ $? -ne 0 ] ; then
  brew install goenv
  goenv install 1.11.4 # 2019/12/13 latest
  ln -s ~/.goenv/shims/go /usr/local/bin/
  ln -s ~/.goenv/shims/godoc /usr/local/bin/
  ln -s ~/.goenv/shims/gofmt /usr/local/bin/
else
  echo "goenv is already installed"
fi

if [ ! -e ~/code ]; then
  mkdir ~/code  # WIP: export GOPATH=~/code
fi

#
# Python
#
brew install python  # install python3, pip3

#
# Ruby
#

#
# Haskell
#

#===============================================================================
# GitHub
#===============================================================================
# https://qiita.com/0ta2/items/25c27d447378b13a1ac3


#===============================================================================
# macOS Apps 
#===============================================================================

echo ">>> Apps settings"

brew cask install google-chrome slack notion sequel-pro slate alfred iterm2 karabiner-elements

# WIP: GHQ style settings
brew tap motemen/ghq
brew install ghq fzf tig ag peco yarn 
brew install neovim/neovim/neovim  

if [ ! -e ~/.config/nvim ]; then
  mkdir -p ~/.config/nvim
fi

