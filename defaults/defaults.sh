# バッテリーのパーセントを表示
defaults write com.apple.menuextra.battery ShowPercent -string "YES" 

# battery 表示
defaults write com.apple.systemuiserver "NSStatusItem Visible com.apple.menuextra.battery" -bool true 
# bluetooth 表示
defaults write com.apple.systemuiserver "NSStatusItem Visible com.apple.menuextra.bluetooth" -bool true 
# volume 表示
defaults write com.apple.systemuiserver "NSStatusItem Visible com.apple.menuextra.volume" -bool true 

# タップでクリックを有効
defaults -currentHost write -g com.apple.mouse.tapBehavior -int 1 
# Automatically hide or show the Dock （Dock を自動的に隠す）
defaults write com.apple.dock autohide -bool true
# Wipe all app icons from the Dock （Dock に標準で入っている全てのアプリを消す、Finder とごみ箱は消えない）
defaults write com.apple.dock persistent-apps -array
# Set the icon size （アイコンサイズの設定）
defaults write com.apple.dock tilesize -int 37
# Magnificate the Dock （Dock の拡大機能を入にする）
defaults write com.apple.dock magnification -bool true
# Bottom right screen corner → Show application windows （右下 → アプリケーションウィンドウ）
defaults write com.apple.dock wvous-br-corner -int 11
defaults write com.apple.dock wvous-br-modifier -int 0
# Dock をすぐに表示する
defaults write com.apple.dock autohide-delay -float 0 
# Dock で開いているアプリケーションのプロセスインジケーターを表示する
defaults write com.apple.dock show-process-indicators -bool true 
# 最近のアプリを非表示
defaults write com.apple.dock show-recents -bool false 
# Set `${HOME}` as the default location for new Finder windows
# 新しいウィンドウでデフォルトでホームフォルダを開く
defaults write com.apple.finder NewWindowTarget -string "PfDe"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"

# Show Status bar in Finder （ステータスバーを表示）
defaults write com.apple.finder ShowStatusBar -bool true

# Show Path bar in Finder （パスバーを表示）
defaults write com.apple.finder ShowPathbar -bool true

# Show Tab bar in Finder （タブバーを表示）
defaults write com.apple.finder ShowTabView -bool true

# Show the ~/Library directory （ライブラリディレクトリを表示、デフォルトは非表示）
chflags nohidden ~/Library

# 拡張子を表示
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Show the hidden files （不可視ファイルを表示）
defaults write com.apple.finder AppleShowAllFiles YES
# 検索をデフォルトでカレントディレクトリ以下にする
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf" 
# 拡張子の変更を警告しない
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false 

# Enable `Tap to click` （タップでクリックを有効にする）
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Map bottom right Trackpad corner to right-click （右下をクリックで、副クリックに割り当てる）
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 2
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true
defaults -currentHost write NSGlobalDomain com.apple.trackpad.trackpadCornerClickBehavior -int 1

defaults -currentHost write NSGlobalDomain com.apple.trackpad.enableSecondaryClick -bool true
# 名前で並べ替えを選択時にディレクトリを前に置く
defaults write com.apple.finder _FXSortFoldersFirst -bool true 
# Desktop で名前で並べ替えを選択時にディレクトリを前に置く
defaults write com.apple.finder _FXSortFoldersFirstOnDesktop -bool true 
# 絶対パスを表示
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true 

# Show the battery percentage from the menu bar （バッテリーのパーセントを表示する）
defaults write com.apple.menuextra.battery ShowPercent -string "YES"
# Date options: Show the day of the week: on （日付表示設定、曜日、秒数を表示）
defaults write com.apple.menuextra.clock 'DateFormat' -string 'EEE H:mm:ss'

# Disable the "Are you sure you want to open this application?" dialog
# 未確認のアプリケーションを実行する際のダイアログを無効にする
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Save screenshots as PNGs （スクリーンショット保存形式をPNGにする）
defaults write com.apple.screencapture type -string "png"

# スクロールバーを常時表示する
defaults write NSGlobalDomain AppleShowScrollBars -string "Always"
# キーリピートの速度
defaults write NSGlobalDomain com.apple.springing.enabled -bool true#defaults write NSGlobalDomain KeyRepeat -int 1 
# キーリピート開始までのタイミング
defaults write NSGlobalDomain InitialKeyRepeat -int 25
# スクロール速度を自分好みに
defaults write -g com.apple.trackpad.scrolling -float 0.5882 
# トラックパッドの軌跡の速さを最大に設定
defaults write -g com.apple.trackpad.scaling -int 3 
# 長押しで連続入力
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

## アニメーション無効

## ウィンドウを開閉するときのアニメーションを無効
defaults write -g NSAutomaticWindowAnimationsEnabled -bool false

## ウィンドウサイズを調整する際の加速再生
defaults write -g NSWindowResizeTime -float 0.001

## Finderで情報ウィンドウを開くときのアニメーションを無効
defaults write com.apple.finder DisableAllAnimations -bool true

## Quick Lookウィンドウのアニメーションをオフ
defaults write -g QLPanelAnimationDuration -float 0

## Dockからアプリを起動するときのアニメーションを無効
defaults write com.apple.dock launchanim -bool false
# 動きを高速化
defaults write -g com.apple.trackpad.scaling 3 && \
defaults write -g com.apple.mouse.scaling 1.5 && \
defaults write -g KeyRepeat -int 1 && \
defaults write -g InitialKeyRepeat -int 10
