umask 022

alias psgrep='ps auxww | grep "\!:1"'
alias dupth='du -d \!:1 \!:2*'
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
zstyle ':zle:*' word-chars " _-./;@"
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

# Set/unset  shell options
#setopt   notify globdots correct pushdtohome cdablevars autolist
#setopt   correctall autocd recexact longlistjobs
#setopt   autoresume histignoredups pushdsilent noclobber
#setopt   autopushd pushdminus extendedglob rcquotes mailwarning
#unsetopt bgnice autoparamslash

# Setup new style completion system. To see examples of the old style (compctl
# based) programmable completion, check Misc/compctl-examples in the zsh
# distribution.
autoload -U compinit
compinit

if [ -f $HOME/.zshrc.local ]; then
    source $HOME/.zshrc.local
fi

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
