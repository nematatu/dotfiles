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

remove_dotfiles_symlink() {
    local target="$1"
    local link_target resolved_target

    [[ -L "$target" ]] || return 0

    link_target="$(readlink "$target")"
    if [[ "$link_target" != /* ]]; then
        link_target="$(cd "$(dirname "$target")" && cd "$(dirname "$link_target")" 2>/dev/null && printf "%s/%s" "$(pwd -P)" "$(basename "$link_target")")" || return 0
    fi
    resolved_target="$(cd "$(dirname "$link_target")" 2>/dev/null && printf "%s/%s" "$(pwd -P)" "$(basename "$link_target")")" || return 0

    case "$resolved_target" in
        "${DOTFILES_DIR}"|"${DOTFILES_DIR}"/*)
            echo "Removing old stow symlink: ${target} -> ${link_target}"
            unlink "$target"
            ;;
    esac
}

remove_dotfiles_symlink "${HOME}/.config"
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

stow --no-folding --dir="${DOTFILES_DIR}" --target="${HOME}" --restow \
    zsh git czg nvim mise sheldon

require_stowed_file() {
    local target="$1"
    if [[ ! -e "$target" ]]; then
        echo "Error: stow did not create required file: ${target}" >&2
        exit 1
    fi
}

require_stowed_file "${HOME}/.zshrc"
require_stowed_file "${HOME}/.zprofile"
require_stowed_file "${HOME}/.aliases"
require_stowed_file "${HOME}/.gitconfig"
require_stowed_file "${HOME}/.czrc"
require_stowed_file "${HOME}/.config/zsh/conf.d/man.zsh"
require_stowed_file "${HOME}/.config/nvim/init.lua"
require_stowed_file "${HOME}/.config/mise/mise.toml"
require_stowed_file "${HOME}/.config/sheldon/plugins.toml"

echo "Common dotfiles linked with stow."
