#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DOTFILES_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
TIMESTAMP="$(date +%Y%m%d%H%M%S)"

if ! command -v stow >/dev/null 2>&1; then
    echo "stow is required." >&2
    exit 1
fi

backup_if_needed() {
    local target="$1"
    if [[ -e "$target" && ! -L "$target" ]]; then
        echo "Backing up existing file: ${target} -> ${target}.backup.${TIMESTAMP}"
        mv "$target" "${target}.backup.${TIMESTAMP}"
    fi
}

mkdir -p "${HOME}/.config"

backup_if_needed "${HOME}/.zshrc"
backup_if_needed "${HOME}/.zprofile"
backup_if_needed "${HOME}/.zsh-vi-mode"
backup_if_needed "${HOME}/.aliases"
backup_if_needed "${HOME}/.gitconfig"
backup_if_needed "${HOME}/.czrc"
backup_if_needed "${HOME}/.config/zsh"
backup_if_needed "${HOME}/.config/nvim"
backup_if_needed "${HOME}/.config/mise/mise.toml"
backup_if_needed "${HOME}/.config/sheldon/plugins.toml"

stow --dir="${DOTFILES_DIR}" --target="${HOME}" --restow \
    zsh git czg nvim mise sheldon

echo "Common dotfiles linked with stow."
