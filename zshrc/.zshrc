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
#

. /usr/local/bin/z.sh

# fpath=(${ASDF_DIR}/completions $fpath)
autoload -Uz compinit && compinit
alias please="sudo"
alias la="ls -a"
alias l="ls"
alias cat="bat"
alias gc="git commit"
alias fzf="fzf --preview='bat {}'"

# [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

