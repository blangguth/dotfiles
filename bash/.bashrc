#       ____   __   ____  _  _  ____   ___ 
#      (  _ \ / _\ / ___)/ )( \(  _ \ / __)
#    _  ) _ (/    \\___ \) __ ( )   /( (__ 
#   (_)(____/\_/\_/(____/\_)(_/(__\_) \___)
#
##########
# about  # My bash with my custom prompt incl. git stats
# author # blangguth <ben.langguth@gmail.com>
# code   # https://github.com/blangguth/dotfiles
##########
#
# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    rxvt-256color) color_prompt=yes;;
esac

#Setting up the prompt with gitprompt
source ~/.bash-git-prompt/prompt-colors.sh
GIT_PROMPT_END_USER=" \n${Magenta}${USER}${ResetColor}@${Blue}${HOSTNAME%%.*}${ResetColor}${ResetColor} $ "
GIT_PROMPT_END_ROOT=" \n${Red}${USER}${ResetColor}@${Blue}${HOSTNAME%%.*}${ResetColor}${ResetColor} $ "
source ~/.bash-git-prompt/gitprompt.sh

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# PATH modifications
export PATH=$PATH:~/.cabal/bin
export PATH=$PATH:~/.xmonad/bin
export PATH=$PATH:~/.npm/bin

# nodejs version manager
export NVM_DIR="/home/blangguth/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

# jump around with z
# https://github.com/rupa/z
. /opt/z/z.sh

# Base16 Shell
# still working on it - having color issues in VIM's AirLine plugin
#BASE16_SHELL="$HOME/.config/base16-shell/base16-eighties.dark.sh"
#[[ -s $BASE16_SHELL ]] && source $BASE16_SHELL
