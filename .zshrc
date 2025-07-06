export ZSH="$HOME/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh
ZSH_THEME="robbyrussell"
plugins=(
    git
    mise
)
source $HOME/.local/bin/antigen.zsh
antigen use oh-my-zsh
antigen bundles <<EOBUNDLES
   # Bundles from the default repo (robbyrussell's oh-my-zsh)
   git
   # Syntax highlighting bundle.
   zsh-users/zsh-syntax-highlighting
   # Fish-like auto suggestions
   zsh-users/zsh-autosuggestions
   # Extra zsh completions
   zsh-users/zsh-completions
   # z
   rupa/z z.sh
   # abbr
   olets/zsh-abbr@main
EOBUNDLES
THEME=denysdovhan/spaceship-prompt
antigen list | grep $THEME; if [ $? -ne 0 ]; then antigen theme $THEME; fi
antigen apply

alias systemv='system_profiler SPSoftwareDataType | grep "System Version" | pbcopy'
alias tle='trans -b en:ja'
alias tlj='trans -b ja:en'
alias rmi="docker rmi $(docker images -q) -f"
alias rmc="docker rm $(docker ps -aq) -f"
fpath=(~/.zsh/completion $fpath)
autoload -U compinit
compinit -u
source ~/.zsh/git-prompt.sh
setopt PROMPT_SUBST
PS1='[%n@%m %c$(__git_ps1 " (%s)")]%% '
alias g='git'
alias gb='git branch'
alias ga.='git add .'
# alias gcm='git commit -m'
abbr -S -qq gcm='git commit -m'
alias gpo='git push origin'
alias gpl='git pull origin'
alias gco='git checkout'
alias gcb='git checkout -b'

function gp.(){
	if [ -z "$1" ]; then
		echo "input commit message"
		return 1
	fi
	git add .
	git commit -m "$1"
	git push origin main
}
# export PATH=/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/System/Cryptexes/App/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin:/opt/X11/bin:/usr/local/sbin:/Users/nekantatsuju/.local/bin:/Users/nekantatsuju/.antigen/bundles/robbyrussell/oh-my-zsh/lib:/Users/nekantatsuju/.antigen/bundles/robbyrussell/oh-my-zsh/plugins/git:/Users/nekantatsuju/.antigen/bundles/zsh-users/zsh-syntax-highlighting:/Users/nekantatsuju/.antigen/bundles/zsh-users/zsh-autosuggestions:/Users/nekantatsuju/.antigen/bundles/zsh-users/zsh-completions:/Users/nekantatsuju/.antigen/bundles/olets/zsh-abbr-main:/Users/nekantatsuju/.antigen/bundles/denysdovhan/spaceship-prompt:/Users/nekantatsuju/local_dev/cogp/
# export PATH=/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/System/Cryptexes/App/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin:/opt/X11/bin:/usr/local/sbin:/Users/nekantatsuju/.local/bin:/Users/nekantatsuju/.antigen/bundles/robbyrussell/oh-my-zsh/lib:/Users/nekantatsuju/.antigen/bundles/robbyrussell/oh-my-zsh/plugins/git:/Users/nekantatsuju/.antigen/bundles/zsh-users/zsh-syntax-highlighting:/Users/nekantatsuju/.antigen/bundles/zsh-users/zsh-autosuggestions:/Users/nekantatsuju/.antigen/bundles/zsh-users/zsh-completions:/Users/nekantatsuju/.antigen/bundles/olets/zsh-abbr-main:/Users/nekantatsuju/.antigen/bundles/denysdovhan/spaceship-prompt:/Users/nekantatsuju/local_dev/cogp/:/Users/nekantatsuju/local_dev/cmprs/
# export PATH=/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/System/Cryptexes/App/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin:/opt/X11/bin:/usr/local/sbin:/Users/nekantatsuju/.local/bin:/Users/nekantatsuju/.antigen/bundles/robbyrussell/oh-my-zsh/lib:/Users/nekantatsuju/.antigen/bundles/robbyrussell/oh-my-zsh/plugins/git:/Users/nekantatsuju/.antigen/bundles/zsh-users/zsh-syntax-highlighting:/Users/nekantatsuju/.antigen/bundles/zsh-users/zsh-autosuggestions:/Users/nekantatsuju/.antigen/bundles/zsh-users/zsh-completions:/Users/nekantatsuju/.antigen/bundles/olets/zsh-abbr-main:/Users/nekantatsuju/.antigen/bundles/denysdovhan/spaceship-prompt:/Users/nekantatsuju/local_dev/cogp/:/Users/nekantatsuju/local_dev/cmprs/:/Users/nekantatsuju/local_dev/cmprsgif/
export PATH=/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/System/Cryptexes/App/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin:/opt/X11/bin:/usr/local/sbin:/Users/nekantatsuju/.local/bin:/Users/nekantatsuju/.antigen/bundles/robbyrussell/oh-my-zsh/lib:/Users/nekantatsuju/.antigen/bundles/robbyrussell/oh-my-zsh/plugins/git:/Users/nekantatsuju/.antigen/bundles/zsh-users/zsh-syntax-highlighting:/Users/nekantatsuju/.antigen/bundles/zsh-users/zsh-autosuggestions:/Users/nekantatsuju/.antigen/bundles/zsh-users/zsh-completions:/Users/nekantatsuju/.antigen/bundles/olets/zsh-abbr-main:/Users/nekantatsuju/.antigen/bundles/denysdovhan/spaceship-prompt:/Users/nekantatsuju/local_dev/cogp/:/Users/nekantatsuju/local_dev/cmprs/:/Users/nekantatsuju/local_dev/cmprsgif/:/Users/nekantatsuju/local_dev/bin
alias copyclip='tee /dev/tty | pbcopy'
export PATH="/opt/local/bin:$PATH"

# bun completions
[ -s "/Users/nekantatsuju/.bun/_bun" ] && source "/Users/nekantatsuju/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
alias mduch='sh $HOME/local_dev/shellScript/touch_mkdir.sh'

# Added by Windsurf
export PATH="/Users/nekantatsuju/.codeium/windsurf/bin:$PATH"

# pnpm
export PNPM_HOME="/Users/nekantatsuju/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
alias cd='cd_func'
cd_func() {
  builtin cd "$@" && eza --icons
}

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

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
alias imgcat='/Users/nekantatsuju/.iterm2/imgcat'

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# fbr - checkout git branch
fbr() {
  local branches branch
  branches=$(git branch -vv) &&
  branch=$(echo "$branches" | fzf +m) &&
  git checkout $(echo "$branch" | awk '{print $1}' | sed "s/.* //")
}
alias ls='eza -a --icons'
export PATH="/usr/local/bin:$PATH"
export TONVIM="$HOME/.config/nvim/lua/"
eval "$(mise activate zsh)"
alias v='nvim'
