#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='\[\e[0;2m\]\$ \[\e[0m\]\u\[\e[0;2m\]@\[\e[0m\]\h \[\e[0m\](\[\e[0m\]\W\[\e[0m\]) \[\e[0;1m\]~ \[\e[0m\]'
