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

ln -sf $PWD/ghostty/config $HOME/.config/ghostty/config

#tic $PWD/terminfo/xterm-color.ti

echo done

