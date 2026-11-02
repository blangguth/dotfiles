#       ____   __   ____  _  _  ____   ___ 
#      (  _ \ / _\ / ___)/ )( \(  _ \ / __)
#    _  ) _ (/    \\___ \) __ ( )   /( (__ 
#   (_)(____/\_/\_/(____/\_)(_/(__\_) \___)
#
##########
# about  # My bash with my custom prompt incl. git stats
# author # blangguth <dev@langguth.io>
# code   # https://github.com/blangguth/dotfiles
##########
#
# ~/.bashrc: executed by bash(1) for interactive non-login shells.
# Login shells must source this file from ~/.bash_profile or ~/.profile.

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# ---------------------------------------------------------------------------
# History
# ---------------------------------------------------------------------------
HISTCONTROL=ignoreboth                 # no duplicates, no lines starting with space
HISTSIZE=100000
HISTFILESIZE=200000
export HISTTIMEFORMAT='%F %T  '        # timestamps in `history`
shopt -s histappend                    # append, don't overwrite

# ---------------------------------------------------------------------------
# Shell options
# ---------------------------------------------------------------------------
shopt -s checkwinsize                  # update LINES/COLUMNS after each command
#shopt -s globstar                     # enable "**" in pathname expansion
#shopt -s dotglob                      # make "*" match dotfiles (dangerous with rm/mv)

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------
# Add a directory to PATH only if it exists and is not already in PATH.
#   path_add DIR         -> append
#   path_add DIR front   -> prepend
path_add() {
    [ -d "$1" ] || return 0
    case ":$PATH:" in
        *":$1:"*) return 0 ;;
    esac
    if [ "$2" = "front" ]; then
        PATH="$1:$PATH"
    else
        PATH="$PATH:$1"
    fi
}

# Same idea for LD_LIBRARY_PATH (append, no leading/trailing colon).
ld_add() {
    [ -d "$1" ] || return 0
    case ":${LD_LIBRARY_PATH:-}:" in
        *":$1:"*) return 0 ;;
    esac
    LD_LIBRARY_PATH="${LD_LIBRARY_PATH:+$LD_LIBRARY_PATH:}$1"
}

# ---------------------------------------------------------------------------
# Prompt
# ---------------------------------------------------------------------------
# chroot name (shown in the terminal title)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# bash-git-prompt: https://github.com/magicmonty/bash-git-prompt
if [ -f "$HOME/.bash-git-prompt/gitprompt.sh" ]; then
    source "$HOME/.bash-git-prompt/prompt-colors.sh"
    GIT_PROMPT_END_USER=" \n${Magenta}${USER}${ResetColor}@${Cyan}${HOSTNAME%%.*}${ResetColor} $ "
    GIT_PROMPT_END_ROOT=" \n${Red}${USER}${ResetColor}@${Cyan}${HOSTNAME%%.*}${ResetColor} $ "
    source "$HOME/.bash-git-prompt/gitprompt.sh"
else
    # Fallback ohne bash-git-prompt (z. B. auf Servern): farbiger Standard-Prompt
    if [ "$(id -u)" -eq 0 ]; then
        PS1='\n\[\e[31m\]\u\[\e[0m\]@\[\e[36m\]\h\[\e[0m\] \w \$ '
    else
        PS1='\n\[\e[35m\]\u\[\e[0m\]@\[\e[36m\]\h\[\e[0m\] \w \$ '
    fi
fi

# Set the terminal title to user@host: dir.
# Done via PROMPT_COMMAND because bash-git-prompt rebuilds PS1 on every prompt
# and would discard a title escape sequence placed in PS1 at startup.
case "$TERM" in
    xterm*|rxvt*)
        __set_title() {
            printf '\033]0;%s%s@%s: %s\007' \
                "${debian_chroot:+($debian_chroot)}" "$USER" "${HOSTNAME%%.*}" "${PWD/#$HOME/\~}"
        }
        ;;
esac

# PROMPT_COMMAND: write history immediately + set title.
# Guarded so that re-sourcing ~/.bashrc does not stack entries.
case ";${PROMPT_COMMAND:-};" in
    *"history -a"*) ;;
    *) PROMPT_COMMAND="history -a${PROMPT_COMMAND:+; $PROMPT_COMMAND}" ;;
esac
if declare -F __set_title >/dev/null; then
    case ";${PROMPT_COMMAND:-};" in
        *"__set_title"*) ;;
        *) PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND; }__set_title" ;;
    esac
fi

# ---------------------------------------------------------------------------
# Aliases and completion
# ---------------------------------------------------------------------------
if [ -f "$HOME/.bash_aliases" ]; then
    . "$HOME/.bash_aliases"
fi

# Programmable completion (not needed if /etc/bash.bashrc already enables it)
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

# ---------------------------------------------------------------------------
# PATH
# ---------------------------------------------------------------------------
path_add "$HOME/.cabal/bin"
path_add "$HOME/.xmonad/bin"
path_add "$HOME/.npm/bin"
path_add "/usr/local/texlive/2021/bin/x86_64-linux"   # check: newer TeX Live year installed?

# user-local tools take precedence over system ones
path_add "$HOME/.opencode/bin" front
path_add "$HOME/.local/bin" front
export PATH

# ---------------------------------------------------------------------------
# Libraries
# ---------------------------------------------------------------------------
# Global LD_LIBRARY_PATH entries can make programs load the wrong libs.
# Remove what you don't really need.
ld_add /usr/local/lib/i386-linux-gnu
ld_add /usr/lib/i386-linux-gnu
ld_add /usr/lib/libreoffice/program
export LD_LIBRARY_PATH

# ---------------------------------------------------------------------------
# Environment
# ---------------------------------------------------------------------------
# Only fall back to :0 if no display is set (keeps SSH/Wayland sessions intact)
export DISPLAY="${DISPLAY:-:0}"

# ---------------------------------------------------------------------------
# Tools
# ---------------------------------------------------------------------------
# nodejs version manager
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

# jump around with z: https://github.com/rupa/z
#[ -f /opt/z/z.sh ] && . /opt/z/z.sh

eval $(keychain --eval --quiet id_rsa)

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv bash)"
. "$HOME/.cargo/env"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
