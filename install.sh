#!/bin/sh

echo "Now copying file..."

PWD=`pwd`
ln -sf $PWD/zshrc/.zshrc ~/

#ln -sf $PWD/tcshrc/.tcshrc ~/
#ln -sf $PWD/tcshrc/.tcshrc.alias ~/
#ln -sf $PWD/tcshrc/.tcshrc.complete ~/
#ln -sf $PWD/tcshrc/.tcshrc.set ~/
#ln -sf $PWD/tcshrc/.tcshrc.bindkey ~/

#ln -sf $PWD/cvsrc/.cvsrc ~/

ln -sf $PWD/emacs/.emacs ~/
ln -sf $PWD/emacs/.emacs.d ~/

#ln -sf $PWD/screenrc/.screenrc ~/

ln -sf $PWD/skk/.skk ~/

ln -sf $PWD/termcap/.termcap ~/.termcap

#ln -sf $PWD/keysnail/.keysnail.js ~/.keysnail.js

ln -sf $PWD/tmux/.tmux.conf ~/.tmux.conf

ln -sf $PWD/vimrc/.vimrc ~/.vimrc

tic $PWD/terminfo/xterm-color.ti

echo done

