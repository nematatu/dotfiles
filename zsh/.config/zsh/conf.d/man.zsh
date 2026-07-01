export DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles/}"
export DOTFILES_JMAN_DIR="$DOTFILES_DIR/man/ja"

if [[ -d "$DOTFILES_JMAN_DIR" ]]; then
    export MANPATH="$DOTFILES_JMAN_DIR:${MANPATH:-}"
fi

export MANPAGER="less -R"
