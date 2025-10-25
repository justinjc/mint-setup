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
export HISTCONTROL=ignoreboth
export HISTIGNORE='pwd:history:exit'
export HISTSIZE=500000
export HISTFILESIZE=500000

# append to the history file, don't overwrite it
shopt -s histappend

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}

prompt_command() {
    local EXIT_CODE="$?"

    PS1="\n"

    # Hostname
    PS1+="\[\e[38;5;130m\]\h \[\e[38;5;240m\]⌂ "

    # Current directory
    PS1+="\[\e[38;5;6m\]\w"

    # Git branch
    local GIT_BRANCH=$(git_branch)
    if [ -n "${GIT_BRANCH:-}" ]; then
        PS1+=" \[\e[38;5;240m\]⎇  \[\e[38;5;2m\]$GIT_BRANCH"
    fi

    # virtualenv
    if [ -n "${VIRTUAL_ENV:-}" ]; then
        PS1+=" \[\e[38;5;58m\](venv)"
    fi

    # Prompt
    if [ $EXIT_CODE = 0 ]; then
        PS1+="\n\[\e[38;5;2m\]▹ "
    else
        PS1+="\n\[\e[38;5;1m\]▸ "
    fi

    # Reset color
    PS1+="\[\e[0m\]"
}

# Exports
export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx
export PROMPT_COMMAND=prompt_command
# Color man pages
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

if [ ! -S ~/.ssh/ssh_auth_sock ]; then
  eval $(ssh-agent) > /dev/null
  ln -sf "$SSH_AUTH_SOCK" ~/.ssh/ssh_auth_sock
fi
export SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock
