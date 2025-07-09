# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi
if [ -d "/usr/local/bin" ] ; then
    PATH="/usr/local/bin:$PATH"
fi

# Set brew path
if [ -z "$(command -v brew)" ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Set Sheldon
eval "$(sheldon source)"

# prioritize brew path (brew 管理の git などを優先させるため)
export PATH="/opt/homebrew/bin/:$PATH"

# Set vscode path
if [ -z "$(command -v code)" ]; then
  export PATH="/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin:$PATH"
fi

# Set mise path
if [ -n "$(command -v mise)" ]; then
  eval "$(mise activate zsh)"
fi

# dotfiles/.bin/ ローカルの.bin/ と分けて管理
export PATH="$HOME/dotfiles/.bin:$PATH"
