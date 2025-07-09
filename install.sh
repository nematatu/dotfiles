#!/usr/bin/env bash
set -uexo pipefail

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

/opt/homebrew/bin/brew bundle install --file ./Brewfile

if ! type xcode-select &> /dev/null; then
    echo "start install Xcode CLT"
    xcode-select --install
else
    echo "Xcode CLT is already installed."
fi

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
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
ln -sf "$NVIM_CONFIG_SRC" "$NVIM_CONFIG_DST"
ln -fnsv "${SCRIPT_DIR}/mise/mise.toml" "${HOME}/mise.toml"

if [[ "$(which mise)" != "" ]]; then
    mise install
else
    echo "install the mise command"
fi
 
if ! which node; then
    $(/opt/homebrew/bin/brew --prefix)/bin/mise use --global node
fi

echo "finish setup!👍"
echo "raycastの設定をimportしてください"
