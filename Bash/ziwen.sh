#!/bin/bash

if [ -f "$HOME/.vimrc" ];then
    echo
    echo "You already have a .vimrc file in your home directory."

    mv ~/.vimrc ~/.vimrc.bak
    mv $1/.vimrc ~/.vimrc 
    ln ~/.vimrc $1/.vimrc

    echo "Your old .vimrc file has been renamed to .vimrc.bak."
    echo "The new .vimrc file has been moved to your home directory and linked."
    echo "Update the new .vimrc file with your custom settings."

    echo
else
    mv $1/.vimrc ~/
    ln ~/.vimrc $1/.vimrc
fi 
 
if [ -f "$HOME/.bash_aliases" ];then
    echo "You already have a .bash_aliases file in your home directory."

    mv ~/.bash_aliases ~/.bash_aliases.bak
    mv $1/.bash_aliases ~/.bash_aliases 
    ln ~/.bash_aliases $1/.bash_aliases

    echo "Your old .bash_aliases file has been renamed to bash_aliases.bak."
    echo "The new .bash_aliases file has been moved to your home directory and linked."
    echo "Update the new .bash_aliases file with your custom settings."  

    echo 
else
    mv $1/.bash_aliases ~/
    ln ~/.bash_aliases $1/.bash_aliases
fi
