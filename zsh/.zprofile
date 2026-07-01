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

if [[ "$(uname -s)" == "Darwin" ]]; then
  # Set brew path
  if ! command -v brew >/dev/null 2>&1 && [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi

  # prioritize brew path (brew 管理の git などを優先させるため)
  export PATH="/opt/homebrew/bin/:$PATH"

  # Set vscode path
  if ! command -v code >/dev/null 2>&1; then
    export PATH="/Applications/Visual Studio Code.app/Contents/Resources/app/bin:$PATH"
  fi
else
  export PATH="$HOME/.local/bin:$HOME/.local/share/mise/bin:$HOME/.local/share/mise/shims:$HOME/.cargo/bin:$HOME/go/bin:/usr/lib/wsl/lib:$PATH"
fi

# Set mise path
if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate zsh)"
fi

# Set Sheldon
if command -v sheldon >/dev/null 2>&1; then
  eval "$(sheldon source)"
fi

# dotfiles/.bin/ ローカルの.bin/ と分けて管理
export PATH="$HOME/dotfiles/.bin:$PATH"
