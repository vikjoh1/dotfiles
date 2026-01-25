eval "$(starship init zsh)"

export EDITOR="nvim"
export SUDO_EDITOR="$EDITOR"
export PGHOST="/var/run/postgresql"

export PATH=$PATH:/usr/local/go/bin:~/go/bin

HISTFILE=~/.history
HISTSIZE=10000
SAVEHIST=50000

autoload -Uz compinit && compinit

setopt inc_append_history

. /usr/local/bin/z.sh

alias please="sudo"
alias ls="eza"
alias la="ls -a"
alias l="ls"
alias cat="bat"
alias fzf="fzf --preview='bat {}'"
alias py="python3"

# android
alias new-android="~/git/android-template/new-project"
alias avds="emulator -list-avds"
alias emu="emulator -avd"
alias adebug="./gradlew installDebug"
alias arelease="./gradlew installRelease"
alias abuild="./gradlew assembleDebug"
alias alog="adb logcat"
alias adevices="adb devices"
alias ashell="adb shell"

# logcat for specific app: alogapp com.example.myapp
alogapp() {
    adb logcat --pid=$(adb shell pidof -s "$1")
}

# git
alias gc="git commit"
alias gs="git status"
alias gp="git push"
alias gpl="git pull"
alias gd="git diff"
alias gsw="git switch"
alias gl="git log --oneline --graph --decorate"

export PATH="${XDG_DATA_HOME:-$HOME/.local/share}/bob/nvim-bin:$PATH"

[ -f "/home/vikjoh/.ghcup/env" ] && . "/home/vikjoh/.ghcup/env" # ghcup-envexport PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

export ANDROID_SDK_ROOT="$HOME/Android/Sdk"
export ANDROID_HOME="$ANDROID_SDK_ROOT"

export PATH="$PATH:$ANDROID_SDK_ROOT/platform-tools"
export PATH="$PATH:$ANDROID_SDK_ROOT/emulator"
export PATH="$PATH:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin"

