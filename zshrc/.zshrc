umask 022

function psgrep() {
    ps auxww | head -n 1
    ps auxww | grep $* | grep -v ps | grep -v grep
}

function dupth() {
    du -h -d $*
}

alias screen='screen -U'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias less='less -XN'

if [ `uname` = 'Darwin' ]; then
    alias ls='ls -FG'
else
    alias ls='ls -F --color=auto'
fi

# Set word range selection
autoload -Uz select-word-style
select-word-style default
zstyle ':zle:*' word-chars " _-./;@:()[]{}"
zstyle ':zle:*' word-style unspecified

cdpath=(.. ~)
setenv() { typeset -x "${1}${1:+=}${(@)argv[2,$#]}" }  # csh compatibility
typeset -U path cdpath fpath manpath

# Hosts to use for completion (see later zstyle)
hosts=(`hostname`)

# Set prompts
PROMPT='%S%m:[%.]%s%% '
RPROMPT=' %~'     # prompt for right side of screen

HISTFILE=$HOME/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt extended_history
setopt share_history

DIRSTACKSIZE=20

autoload -U compinit
compinit

zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z} r:|[-_.]=**'

if [ -f $HOME/.zshrc.local ]; then
    source $HOME/.zshrc.local
fi

