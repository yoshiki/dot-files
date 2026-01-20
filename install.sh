#!/bin/sh

echo "Now copying file..."

PWD=`pwd`
ln -sf $PWD/zshrc/.zshrc $HOME/

#ln -sf $PWD/tcshrc/.tcshrc $HOME/
#ln -sf $PWD/tcshrc/.tcshrc.alias $HOME/
#ln -sf $PWD/tcshrc/.tcshrc.complete $HOME/
#ln -sf $PWD/tcshrc/.tcshrc.set $HOME/
#ln -sf $PWD/tcshrc/.tcshrc.bindkey $HOME/

#ln -sf $PWD/cvsrc/.cvsrc $HOME/

ln -sf $PWD/emacs/.emacs $HOME/
ln -sf $PWD/emacs/.emacs.d $HOME/

#ln -sf $PWD/screenrc/.screenrc $HOME/

ln -sf $PWD/skk/.skk $HOME/

ln -sf $PWD/termcap/.termcap $HOME/.termcap

#ln -sf $PWD/keysnail/.keysnail.js $HOME/.keysnail.js

ln -sf $PWD/tmux/.tmux.conf $HOME/.tmux.conf

ln -sf $PWD/vimrc/.vimrc $HOME/.vimrc

if [ ! -d $HOME/.config ]; then
    mkdir $HOME/.config
fi

if [ ! -d $HOME/.config/ghostty ]; then
    mkdir $HOME/.config/ghostty
fi

ln -sf $PWD/ghostty/config $HOME/.config/ghostty/config

if [ ! -d $HOME/.config/alacritty ]; then
    mkdir $HOME/.config/alacritty
fi

ln -sf $PWD/alacritty/alacritty.toml $HOME/.config/alacritty

echo "Please clone alacritty theme from https://github.com/alacritty/alacritty-theme"

#tic $PWD/terminfo/xterm-color.ti

echo done

