#!/usr/bin/env bash
set -ueo pipefail

PATH="$PATH:/opt/homebrew/bin"

# HomeBrewのインストール
if [ "$(uname)" = "Darwin" ]; then
    if ! type brew &> /dev/null; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)";
    else
        echo "HomeBrew is already installed."
    fi
else
    echo "Not macOS!"
fi

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

/opt/homebrew/bin/brew bundle install --file "${SCRIPT_DIR}/Brewfile"

if ! type xcode-select &> /dev/null; then
    echo "start install Xcode CLT"
    xcode-select --install
else
    echo "Xcode CLT is already installed."
fi

TIMESTAMP=$(date +%Y%m%d%H%M%S)

for dir in "${SCRIPT_DIR}"/*/; do
    [[ "$dir" == "${SCRIPT_DIR}/.git/" ]] && continue
    [[ "$dir" == "${SCRIPT_DIR}"/.github/ ]] && continue

    for dotfile in "${dir}".??* ; do
        if [[ -f "$dotfile" ]]; then
            TARGET_PATH="$HOME/$(basename "$dotfile")"
            if [[ -e "$TARGET_PATH" && ! -L "$TARGET_PATH" ]]; then
                echo "Backing up extisting file: $TARGET_PATH -> ${TARGET_PATH}.backup.${TIMESTAMP}"
                mv "$TARGET_PATH" "${TARGET_PATH}.backup.${TIMESTAMP}"
            fi
            ln -fnsv "$dotfile" "$TARGET_PATH"
        fi
    done
done

# --- Neovimの設定 ---
NVIM_CONFIG_SRC="${SCRIPT_DIR}/nvim"
NVIM_CONFIG_DST="${HOME}/.config/nvim"

echo "Creating symlink for Neovim config..."

# .configディレクトリがなければ作成
mkdir -p "$(dirname "$NVIM_CONFIG_DST")"

# 既存のnvim設定があればバックアップを作成
if [ -e "$NVIM_CONFIG_DST" ] && [ ! -L "$NVIM_CONFIG_DST" ]; then
    echo "Backing up existing nvim config to ${NVIM_CONFIG_DST}.bak"
    mv "$NVIM_CONFIG_DST" "${NVIM_CONFIG_DST}.bak"
fi

# シンボリックリンクを作成（既に存在する場合は上書き）
ln -fnsv "$NVIM_CONFIG_SRC" "$NVIM_CONFIG_DST"

# --- miseの設定 ---
MISE_CONFIG_DST="${HOME}/.config/mise"
mkdir -p "$MISE_CONFIG_DST"
ln -fnsv "${SCRIPT_DIR}/mise/mise.toml" "${MISE_CONFIG_DST}/mise.toml"

# .configディレクトリがなければ作成
SHELDON_CONFIG_DST="${HOME}/.config/sheldon"
mkdir -p "$SHELDON_CONFIG_DST"
ln -fnsv "${SCRIPT_DIR}/sheldon/plugins.toml" "${HOME}/.config/sheldon/plugins.toml"

KARABINER_CONFIG_DST="${HOME}/.config/karabiner"
mkdir -p "$KARABINER_CONFIG_DST"
ln -fnsv "${SCRIPT_DIR}/karabinerElements/karabiner.json" "${KARABINER_CONFIG_DST}/karabiner.json"

if [[ "$(which mise)" != "" ]]; then
    mise install
else
    echo "install the mise command"
fi

if ! which node; then
    $(/opt/homebrew/bin/brew --prefix)/bin/mise use --global node
fi

sh "${SCRIPT_DIR}/defaults/defaults.sh"

echo "finish setup!✨"
echo "raycastの設定をimportしてください"
echo "ghコマンドでGitHub認証を行ってください"
echo "karabinerElementsのdevicesの設定をしてください"
echo "linearmouseの設定をしてください"
echo "google日本語入力で設定ファイルをimport & 英数字、記号をを半角に設定してください"
echo "google日本語入力をデフォルトにしてください"
echo "Chromeをデフォルトにしてください"
echo "iTerm2の設定をimportしてください & Hack Nerd Fontを設定 & 15ptにしてください"
echo "再起動してください"
