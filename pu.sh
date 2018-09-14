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

########## Variables

dots="$PWD"
master_dot=$HOME/.bash_profile
old_dots=$HOME/.old_dots  # directory to back up any existing dotfiles to
local_dots=".work_profile .local/.env" # list of files/folders that need to live locally
symlinks=".githelpers .bash_prompt .sdubs_profile"  # list of files/folders in this repo to symlink in homedir


########## If we don't have $master_dot (.bash_profile) or backup folder (.old_dots/), create them

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

########## Symlink dotfiles that can live in this repo

# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks
# TODO: can this be simplified by just sourcing bash_prompt and sdubs_profile separately?
echo "Checking for existing symlink dotfiles ($symlinks)..."
for file in $symlinks; do
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

########## Create dotfiles that need to live locally

echo "Checking for existing local dotfiles ($local_dots)..."
for file in $local_dots; do
    if [[ ! -f $HOME/$file ]] ; then
        echo "Creating $file..."
        touch $HOME/$file
        echo -e "# Local config: $file \n" >> $HOME/$file
    else
        echo "$file already exists, skipping..."
    fi
done

########## Source other dotfiles into master

# source symlink files
## TODO: fix this loop, can it be simplified?
if grep -q $dots "$master_dot"; then
    echo "Custom files already linked, skipping..."
else
    echo "Linking custom profiles..."
    echo "source $dots/.sdubs_profile" >> "$master_dot"
fi

# source local files
## TODO: can I symlink only one file?
for file in $local_dots; do
    if grep -q $dots "$master_dot"; then
        echo "Custom files already linked, skipping..."
    else
        echo "Linking custom profiles..."
        echo "source $dots/.sdubs_profile" >> "$master_dot"
    fi
done


########## Set up helpers

# Add githelpers, gitconfig, and gitignore
echo "Setting up custom gitconfig..."
ln -fs "$dots/.githelpers" "$HOME/.githelpers"
git config --global include.path "$dots/.gitconfig"
git config --global core.excludesfile "$dots/.gitignore_global"

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
echo "Please re-source the master dotfile to get the new hotness."
echo "e.g. \`source $master_dot\`"
