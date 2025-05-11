eval "$(starship init zsh)"

export EDITOR="nvim"
export SUDO_EDITOR="$EDITOR"
export PGHOST="/var/run/postgresql"

export PATH=$PATH:/usr/local/go/bin

HISTFILE=~/.history
HISTSIZE=10000
SAVEHIST=50000

autoload -Uz compinit && compinit

setopt inc_append_history

# . "$HOME/.asdf/asdf.sh"
#

. /usr/local/bin/z.sh

# fpath=(${ASDF_DIR}/completions $fpath)
alias please="sudo"
alias la="ls -a"
alias l="ls"
alias cat="bat"
alias fzf="fzf --preview='bat {}'"

# git
alias gc="git commit"
alias gs="git status"
alias gp="git push"
alias gpl="git pull"
alias gd="git diff"
alias gsw="git switch"
alias gl="git log --oneline --graph --decorate"

# [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

