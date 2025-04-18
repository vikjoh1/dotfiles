eval "$(starship init zsh)"

export EDITOR="nvim"
export SUDO_EDITOR="$EDITOR"
export PGHOST="/var/run/postgresql"

export PATH=$PATH:/usr/local/go/bin

HISTFILE=~/.history
HISTSIZE=10000
SAVEHIST=50000

setopt inc_append_history

# . "$HOME/.asdf/asdf.sh"

# fpath=(${ASDF_DIR}/completions $fpath)
autoload -Uz compinit && compinit
alias please="sudo"

# [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

