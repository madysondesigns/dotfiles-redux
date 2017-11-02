#!/bin/bash

########## Variables

dots="$PWD"
master_dot=$HOME/.bash_profile
work_dot=$HOME/.work_profile
old_dots=$HOME/.old_dots  # directory to back up any existing dotfiles to
files=".githelpers .bash_prompt .sdubs_profile"  # list of files/folders in this repo to symlink in homedir

########## Link dotfiles that need to be in ~/

# create dots_old in homedir
if [[ ! -d $old_dots ]]; then
    echo "Creating $old_dots for backup of any existing dotfiles in ~/"
    mkdir -p $old_dots
fi

# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks
echo "Checking for existing dotfiles ($files)..."
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

# If we don't have $master_dot (.bash_profile), create it
if [[ ! -f "$master_dot" ]] ; then
    echo "Creating $master_dot..."
    touch "$master_dot"
else
    echo "$master_dot already exists, skipping..."
fi

# If we don't have $work_dot (.work_profile), create it
if [[ ! -f "$work_dot" ]] ; then
    echo "Creating $work_dot..."
    touch "$work_dot"
    echo -e "# Work-specific config stuff \n" >> $work_dot
else
    echo "$work_dot already exists, skipping..."
fi

if grep -q $dots "$master_dot"; then
    echo "Custom files already linked, skipping..."
else
    echo "Linking custom profiles..."
    echo "source $dots/.sdubs_profile" >> "$master_dot"
    echo "source $work_dot" >> "$master_dot"
fi

# Add dotfiles .gitconfig to ~/.gitconfig
echo "Linking custom gitconfig..."
git config --global include.path "$dots/.gitconfig"
git config --global core.excludesfile "$dots/.gitignore_global"


########## Set up helpers

# Create .bin in home dir
mkdir -p $HOME/.bin

# Sublime Text
if [[ -d "/Applications/Sublime Text.app/" ]]; then
    echo "Installing subl alias..."
    ln -fs "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" ~/.bin/subl
else
    echo "Sublime Text not installed."
fi


########## Re-source main .profile
echo "Re-sourcing $master_dot..."
. $master_dot
