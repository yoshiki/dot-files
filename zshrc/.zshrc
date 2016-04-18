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

zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z} r:|[-_]=*'
zstyle ':completion:*:cd:*' tag-order local-directories path-directories
zstyle ':completion:*:default' menu select=1

case "${TERM}" in
kterm*|xterm*)
    export LSCOLORS=gxfxcxdxbxegedabagacad
    export LS_COLORS='di=36:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
    zstyle ':completion:*' list-colors 'di=36' 'ln=35' 'so=32' 'ex=31' 'bd=46;34' 'cd=43;34'
    ;;
cons25)
    unset LANG
    export LSCOLORS=ExFxCxdxBxegedabagacad
    export LS_COLORS='di=01;34:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
    zstyle ':completion:*' list-colors 'di=;34;1' 'ln=;35;1' 'so=;32;1' 'ex=31;1' 'bd=46;34' 'cd=43;34'
    ;;
esac

if [ -f $HOME/.zshrc.local ]; then
    source $HOME/.zshrc.local
fi


# Add environment variable COCOS_CONSOLE_ROOT for cocos2d-x
export COCOS_CONSOLE_ROOT=/Users/yoshiki/local/share/cocos2d-x-3.8.1/tools/cocos2d-console/bin
export PATH=$COCOS_CONSOLE_ROOT:$PATH

# Add environment variable COCOS_TEMPLATES_ROOT for cocos2d-x
export COCOS_TEMPLATES_ROOT=/Users/yoshiki/local/share/cocos2d-x-3.8.1/templates
export PATH=$COCOS_TEMPLATES_ROOT:$PATH

# Add environment variable ANDROID_SDK_ROOT for cocos2d-x
export ANDROID_SDK_ROOT=/Users/yoshiki/Library/Android/sdk
export PATH=$ANDROID_SDK_ROOT:$PATH
export PATH=$ANDROID_SDK_ROOT/tools:$ANDROID_SDK_ROOT/platform-tools:$PATH
