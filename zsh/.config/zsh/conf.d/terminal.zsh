if [[ -o interactive ]]; then
  infocmp "$TERM" >/dev/null 2>&1 || export TERM=xterm-256color
  stty erase '^?' 2>/dev/null
  bindkey -e
  bindkey '^?' backward-delete-char
  bindkey '^H' backward-delete-char
fi
