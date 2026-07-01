#!/usr/bin/env bash
set -euo pipefail

PATH="$PATH:/opt/homebrew/bin"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DOTFILES_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

if ! type brew &> /dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "Homebrew is already installed."
fi

softwareupdate --install-rosetta --agree-to-license
/opt/homebrew/bin/brew bundle install --file "${DOTFILES_DIR}/Brewfile"

if ! type xcode-select &> /dev/null; then
    echo "start install Xcode CLT"
    xcode-select --install
else
    echo "Xcode CLT is already installed."
fi

"${SCRIPT_DIR}/link-common.sh"

KARABINER_CONFIG_DST="${HOME}/.config/karabiner"
mkdir -p "$KARABINER_CONFIG_DST"
ln -fnsv "${DOTFILES_DIR}/karabinerElements/karabiner.json" "${KARABINER_CONFIG_DST}/karabiner.json"

if command -v mise &> /dev/null; then
    mise install --cd "$HOME"
else
    echo "install the mise command"
fi

if ! command -v node &> /dev/null; then
    "$(brew --prefix)/bin/mise" use --global node
fi

sh "${DOTFILES_DIR}/defaults/defaults.sh"

echo "finish setup!"
echo "raycastの設定をimportしてください"
echo "ghコマンドでGitHub認証を行ってください"
echo "karabinerElementsのdevicesの設定をしてください"
echo "linearmouseの設定をしてください"
echo "google日本語入力で設定ファイルをimport & 英数字、記号を半角に設定してください"
echo "google日本語入力をデフォルトにしてください"
echo "Chromeをデフォルトにしてください"
echo "iTerm2の設定をimportしてください & Hack Nerd Fontを設定 & 15ptにしてください"
echo "再起動してください"
