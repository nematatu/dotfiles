export PATH="/opt/homebrew/bin:$PATH"

autoload -Uz compinit
compinit

eval "$(sheldon source)"
eval "$(mise activate zsh)"

[ -f ${HOME}/.aliases ] && source ${HOME}/.aliases

export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow'
export FZF_DEFAULT_OPTS="
--multi --border=rounded --height 85% --layout=reverse
--preview \"bat --style=numbers --color=always {}\"
--preview-window=down,50%,wrap
--color=border:#b4befe,fg:#a9b1d6,fg+:#a6e3a1,hl:#f5c2e7,hl+:#89b4fa,bg+:#11111b,pointer:#f38ba8,prompt:#89dceb,info:#b4befe,header:#a6e3a1,scrollbar:#eba0ac,preview-scrollbar:#eba0ac,preview-border:#89dceb
"
export FZF_CTRL_T_COMMAND='
  rg --files --no-ignore --hidden --follow \
  --glob "!{.git,.cache,Library,Downloads,Movies,.DS_Store,.zsh_sessions, Music, Applications (Parallels) , .pyenv}/**"
'
export FZF_CTRL_T_OPTS="
  --preview 'bat -n --color=always {}'
  --bind '?:toggle-preview'
"
export FZF_ALT_C_COMMAND='fd --type d'
export FZF_ALT_C_OPTS="--preview 'eza --tree --icons --color=always {} | head -200'"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

function gcd() {
  cd $(ghq list -p | fzf)
}

# pnpm
export PNPM_HOME="/Users/nematatu/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

export DYLD_LIBRARY_PATH="$(brew --prefix)/lib:$DYLD_LIBRARY_PATH"
  autoload -Uz add-zsh-hook

  _set_project_title() {
        local root name
        root=$(git rev-parse --show-toplevel 2>/dev/null)

        if [[ -n "$root" ]]; then
                name=${root:t}   # 例: kotobad
        else
                name=${PWD:t}
        fi

        printf '\033]2;%s\007' "$name"
  }

  add-zsh-hook chpwd _set_project_title
  add-zsh-hook precmd _set_project_title
  _set_project_title

# Vite+ bin (https://viteplus.dev)
. "$HOME/.vite-plus/env"
