# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# Set Colors
export FG_Black="\033[0;30m"
export FG_GrayBold="\033[1;30m"
export FG_Blue="\033[0;34m"
export FG_BlueBold="\033[1;34m"
export FG_Green="\033[0;32m"
export FG_GreenBold="\033[1;32m"
export FG_Cyan="\033[0;36m"
export FG_CyanBold="\033[1;36m"
export FG_Red="\033[0;31m"
export FG_RedBold="\033[1;31m"
export FG_Purple="\033[0;35m"
export FG_PurpleBold="\033[1;35m"
export FG_Yellow="\033[0;33m"
export FG_YellowBold="\033[1;33m"
export FG_Gray="\033[0;37m"
export FG_WhiteBold="\033[1;37m"
export FG_Default="\033[m"
export BG_Black="\033[40m"
export BG_Red="\033[41m"
export BG_Green="\033[42m"
export BG_Yellow="\033[43m"
export BG_Blue="\033[44m"
export BG_Purple="\033[45m"
export BG_Cyan="\033[46m"
export BG_Gray="\033[47m"
export BG_Default="\033[m"

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    PS1="\n\[$FG_GreenBold\][\@] \[$FG_Red\]${debian_chroot:+($debian_chroot)}\[$FG_Cyan\]\u@\h \[$FG_BlueBold\]\w\[$FG_Yellow\]\`__git_ps1\` \n\[$FG_Gray\]\# \$\[$FG_Default\] "
    PS2="\[$FG_Gray\]\# >\[$FG_Default\]   "

else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
#if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
#    . /etc/bash_completion
#fi
