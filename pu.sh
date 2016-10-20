#!/bin/bash

########## Variables

dots="$PWD"
old_dots=~/.old_dots             # old dotfiles backup directory
master_dot=~/.profile
files=".githelpers .bash_prompt"         # list of files/folders to symlink in homedir

########## Link dotfiles that need to be in ~

# create dots_old in homedir
if [[ ! -d $old_dots ]]; then
    echo "Creating $old_dots for backup of any existing dotfiles in ~/"
    mkdir -p $old_dots
fi

# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks
for file in $files; do
    if [[ -f $file ]]; then
        echo "Moving existing $file from ~ to $old_dots..."

        if [[ -f $old_dots/$file ]]; then
            echo "Backup $file already exists, deleting..."
            rm $old_dots/$file
        fi

        mv ~/$file $old_dots
    elif [[ ! -L $file ]]; then
        echo "Symlink to $file already exists, deleting..."
        unlink ~/$file
    fi

    echo "Creating symlink to $file in home directory..."
    ln -s $dots/$file ~/$file
done


########## Source other dotfiles

# If we don't have $master_dot (.profile), create it
if [ ! -f "$master_dot" ] ; then
    touch "$master_dot"
fi

if grep -q $dots "$master_dot"; then
    echo "Custom files already linked, skipping..."
else
    echo "Linking custom profiles..."
    echo "source $dots/.sdubs_profile" >> "$master_dot"
    echo "source $dots/.better_profile" >> "$master_dot"
fi

# Add dotfiles .gitconfig to ~/.gitconfig
echo "Linking custom gitconfig..."
git config --global include.path "$dots/.gitconfig"
git config --global core.excludesfile "$dots/.gitignore_global"


########## Re-source main .profile
echo "Re-sourcing $master_dot..."
source ~/.profile
# source ~/.vimrc
