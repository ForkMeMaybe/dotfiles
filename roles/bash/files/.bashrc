#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

# initialize starship
eval "$(starship init bash)"

# Default cache location
export XDG_CACHE_HOME="$HOME/.cache"
