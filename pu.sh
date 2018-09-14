#!/bin/bash

echo "Setting up dotfiles..."

###############################################################################
# Run initial setup
# Symlinks dev and Dropbox folders, sets up Homebrew stuff
###############################################################################
echo "Bootstrapping... (enter to skip)"
read -t 3 -n 1 answer
if [ $? == 0 ]; then
    echo "Skipping."
else
    sh ./bootstrap.sh
fi


###############################################################################
# Variables
###############################################################################

dots="$PWD"
master_dot=$HOME/.bash_profile
old_dots=$HOME/.old_dots
local_dot=$HOME/.local_profile
sym_dots=".githelpers .bash_prompt .sdubs_profile"


###############################################################################
# Crete master file and backup folder if needed
###############################################################################
if [[ ! -f "$master_dot" ]] ; then
    echo "Creating $master_dot..."
    touch "$master_dot"
else
    echo "$master_dot already exists, skipping..."
fi

if [[ ! -d $old_dots ]]; then
    echo "Creating $old_dots for backup of any existing dotfiles in ~/"
    mkdir -p $old_dots
fi


###############################################################################
# Symlink dotfiles that live in this repo
###############################################################################
echo "Checking for existing symlink dotfiles ($sym_dots)..."
for file in $sym_dots; do
    if [[ -L $HOME/$file ]]; then
        echo "Symlink to $file already exists, deleting..."
        unlink $HOME/$file
    elif [[ -f $HOME/$file ]]; then
        echo "Moving existing $file from ~/ to $old_dots..."

        if [[ -f $old_dots/$file ]]; then
            echo "Backup $file already exists, deleting..."
            rm $old_dots/$file
        fi

        mv ~/$file $old_dots
    fi

    echo "Creating symlink to $file in home directory..."
    ln -s $dots/$file $HOME/$file
done


###############################################################################
# Create a dotfile for local config
###############################################################################
echo "Checking for existing local config ($local_dot)..."
if [[ ! -f "$local_dot" ]] ; then
    echo "Creating $local_dot..."
    touch "$local_dot"
    echo -e "# Config specific to this machine \n" >> $local_dot
else
    echo "$local_dot already exists, skipping..."
fi

###############################################################################
# Source dotfiles into master
###############################################################################
if grep -q "sdubs_profile" "$master_dot"; then
    echo "Custom files already linked, skipping..."
else
    echo "Linking custom profiles..."
    echo "source $HOME/.sdubs_profile" >> "$master_dot"
fi

if grep -q $local_dot "$master_dot"; then
    echo "Local files already linked, skipping..."
else
    echo "Linking local profiles..."
    echo "source $local_dot" >> "$master_dot"
fi


###############################################################################
# Set up helpers
###############################################################################
echo "Setting up custom gitconfig..."
git config --global include.path "$dots/.gitconfig"
git config --global core.excludesfile "$dots/.gitignore_global"

mkdir -p $HOME/.bin

if [[ -d "/Applications/Sublime Text.app/" ]]; then
    echo "Installing subl alias..."
    ln -fs "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" ~/.bin/subl
else
    echo "Sublime Text not installed."
fi


###############################################################################
# Success!
###############################################################################
echo "Please re-source the master dotfile to get the new hotness."
echo "e.g. \`source $master_dot\`"
