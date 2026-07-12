umask 022

function psgrep() {
    ps auxww | head -n 1
    ps auxww | grep $* | grep -v ps | grep -v grep
}

function dupth() {
    du -h -d $*
}

ghq-src () {
    local repo=$(ghq list | fzf)
    if [ -n "$repo" ]; then
        repo=$(ghq list --full-path --exact $repo)
        BUFFER="cd ${repo}"
        zle accept-line
    fi
    zle clear-screen
}
zle -N ghq-src
bindkey '^]' ghq-src


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
select-word-style bash
zstyle ':zle:*' word-chars " _-./;@:()[]{}="
zstyle ':zle:*' word-style unspecified

cdpath=(.. ~)
setenv() { typeset -x "${1}${1:+=}${(@)argv[2,$#]}" }  # csh compatibility
typeset -U path cdpath fpath manpath

# Hosts to use for completion (see later zstyle)
hosts=(`hostname`)

# Set prompts
autoload -Uz vcs_info
setopt prompt_subst

zstyle ':vcs_info:*' formats '%s(%F{green}%b%f)'
zstyle ':vcs_info:*' actionformats '%s(%F{green}%b%f(%F{red}%a%f)'
precmd() { vcs_info }

PROMPT='%S%m:[%.]%s%% '
RPROMPT='${vcs_info_msg_0_}'

HISTFILE=$HOME/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt extended_history
setopt share_history

DIRSTACKSIZE=20

zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z} r:|[-_.]=**'
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

# Set PATH, MANPATH, etc., for Homebrew.
eval "$(/opt/homebrew/bin/brew shellenv)"

if type brew &>/dev/null
then
  fpath=($(brew --prefix)/share/zsh/site-functions ${fpath})
  autoload -Uz compinit && compinit -i
fi

if [ -f $HOME/.zshrc.local ]; then
    source $HOME/.zshrc.local
fi

