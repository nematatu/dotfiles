#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd -P)"
DOTFILES_DIR="$(cd "${SCRIPT_DIR}/.." && pwd -P)"

remove_dotfiles_symlink() {
    local target="$1"
    local link_target resolved_target

    [[ -L "$target" ]] || return 0

    link_target="$(readlink "$target")"
    if [[ "$link_target" != /* ]]; then
        link_target="$(cd "$(dirname "$target")" && cd "$(dirname "$link_target")" 2>/dev/null && printf "%s/%s" "$(pwd -P)" "$(basename "$link_target")")" || link_target="$(readlink "$target")"
    fi
    resolved_target="$(cd "$(dirname "$link_target")" 2>/dev/null && printf "%s/%s" "$(pwd -P)" "$(basename "$link_target")")" || resolved_target="$link_target"

    case "$resolved_target:$link_target" in
        "${DOTFILES_DIR}"*:*|*dotfiles*:*)
            echo "Removing old dotfiles symlink: ${target} -> $(readlink "$target")"
            unlink "$target"
            ;;
    esac
}

restore_source_if_needed() {
    local source_file="$1"
    local backup_file

    [[ ! -e "$source_file" ]] || return 0

    backup_file="$(find "$(dirname "$source_file")" -maxdepth 1 -type f -name "$(basename "$source_file").backup.*" | sort | tail -n 1)"
    if [[ -n "$backup_file" ]]; then
        echo "Restoring dotfile source: ${backup_file} -> ${source_file}"
        mv "$backup_file" "$source_file"
    fi
}

cleanup_backup_symlinks() {
    local dir="$1"
    [[ -d "$dir" ]] || return 0

    find "$dir" -maxdepth 1 -type l -name '*.backup.*' | while IFS= read -r link; do
        remove_dotfiles_symlink "$link"
    done
}

mkdir -p "${HOME}/.config"

remove_dotfiles_symlink "${HOME}/.config"
remove_dotfiles_symlink "${HOME}/.czrc"
remove_dotfiles_symlink "${HOME}/.gitconfig"
remove_dotfiles_symlink "${HOME}/.aliases"
remove_dotfiles_symlink "${HOME}/.zprofile"
remove_dotfiles_symlink "${HOME}/.zsh-vi-mode"
remove_dotfiles_symlink "${HOME}/.zshrc"
remove_dotfiles_symlink "${HOME}/.config/zsh"
remove_dotfiles_symlink "${HOME}/.config/nvim"
remove_dotfiles_symlink "${HOME}/.config/mise"
remove_dotfiles_symlink "${HOME}/.config/sheldon"
remove_dotfiles_symlink "${HOME}/.config/mise/mise.toml"
remove_dotfiles_symlink "${HOME}/.config/sheldon/plugins.toml"

cleanup_backup_symlinks "${HOME}/.config/mise"
cleanup_backup_symlinks "${HOME}/.config/sheldon"

restore_source_if_needed "${DOTFILES_DIR}/mise/.config/mise/mise.toml"
restore_source_if_needed "${DOTFILES_DIR}/sheldon/.config/sheldon/plugins.toml"

echo "Stow link repair finished. Run ./install.sh next."
