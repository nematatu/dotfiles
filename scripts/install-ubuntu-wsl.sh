#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DOTFILES_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

if [[ "$(uname -s)" != "Linux" ]]; then
    echo "This installer is for Linux/WSL." >&2
    exit 1
fi

if ! grep -qiE "microsoft|wsl" /proc/version 2>/dev/null; then
    echo "Warning: WSL を検出できませんでした。Ubuntu Linux として続行します。"
fi

sudo apt update
sudo apt install -y \
    zsh git curl ca-certificates gnupg lsb-release \
    build-essential pkg-config unzip zip \
    cmake clang-format \
    ripgrep fd-find fzf bat neovim tmux stow \
    jq htop

for package in gh eza nvtop imagemagick libmagickwand-dev libavif-bin; do
    sudo apt install -y "$package" || echo "Warning: apt package ${package} could not be installed." >&2
done

mkdir -p "${HOME}/.local/bin"
if ! command -v fd >/dev/null 2>&1 && command -v fdfind >/dev/null 2>&1; then
    ln -fnsv "$(command -v fdfind)" "${HOME}/.local/bin/fd"
fi
if ! command -v bat >/dev/null 2>&1 && command -v batcat >/dev/null 2>&1; then
    ln -fnsv "$(command -v batcat)" "${HOME}/.local/bin/bat"
fi

export PATH="${HOME}/.local/bin:${HOME}/.local/share/mise/bin:${HOME}/.local/share/mise/shims:${PATH}"

if ! command -v mise >/dev/null 2>&1; then
    curl https://mise.run | sh
fi

"${SCRIPT_DIR}/link-common.sh"

add_mise_bin_paths() {
    command -v mise >/dev/null 2>&1 || return 0
    eval "$(mise env -s bash --cd "$HOME" 2>/dev/null || true)"
    while IFS= read -r bin_path; do
        if [[ -n "$bin_path" && -d "$bin_path" ]]; then
            case ":$PATH:" in
                *":$bin_path:"*) ;;
                *) export PATH="$bin_path:$PATH" ;;
            esac
        fi
    done < <(mise bin-paths --cd "$HOME" 2>/dev/null || true)
}

if command -v mise >/dev/null 2>&1; then
    mise install --cd "$HOME" || echo "Warning: mise install failed. 必要なツールは後で mise install --cd \"$HOME\" を再実行してください。" >&2
    mise install --cd "$HOME" \
        aqua:x-motemen/ghq@latest \
        aqua:jesseduffield/lazygit@latest \
        aqua:rossmacarthur/sheldon@latest \
        aqua:sxyazi/yazi@latest \
        || echo "Warning: mise install for aqua tools failed." >&2
    mise reshim || true
    add_mise_bin_paths
    hash -r
fi

if command -v zsh >/dev/null 2>&1; then
    ZSH_PATH="$(command -v zsh)"
    if [[ "${SHELL:-}" != "$ZSH_PATH" ]]; then
        echo "Changing default shell to ${ZSH_PATH}"
        chsh -s "$ZSH_PATH"
    fi
fi

for command_name in zsh git nvim rg fd bat fzf stow gh ghq lazygit mise sheldon node python go cargo clang-format avifenc rclone codex yazi; do
    command -v "$command_name" >/dev/null 2>&1 || mise exec -C "$HOME" -- bash -lc "command -v '$command_name'" >/dev/null 2>&1 || echo "Warning: ${command_name} is not available on PATH." >&2
done

cat <<'EOF'
WSL Ubuntu setup finished.

次の確認をしてください:
  exec zsh -l
  nvidia-smi
  gh auth login

CUDA Toolkit が必要な場合は、WSL 内に Linux NVIDIA driver を入れず、WSL-Ubuntu 用の CUDA Toolkit だけを入れてください。
EOF
