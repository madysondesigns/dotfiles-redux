#!/bin/bash

echo "Running bootstrap stuff..."

###############################################################################
# Dev path setup
# These dotfiles assume you'll be using ~/src/ for all dev work.
# If you need  different name for some reason, this will set up a symlink.
###############################################################################
default_dev_path="src"

echo "If using a dev folder other than ~/$default_dev_path, enter it:"

read local_dev_path

if [ -z "$local_dev_path" ]
then
    echo "Using default ~/$default_dev_path path for setup..."
else
    echo "Symlinking ~/$local_dev_path to ~/$default_dev_path..."
    ln -s $HOME/$default_dev_path $HOME/$local_dev_path
fi

###############################################################################
# Dropbox setup
# These dotfiles assume the default Dropbox location of ~/Dropbox.
# If you need  different name for some reason, this will set up a symlink.
###############################################################################
default_dropbox_path="Dropbox"

echo "If using a Dropbox folder other than ~/$default_dropbox_path, enter it:"

read local_dropbox_path

if [ -z "$local_dropbox_path" ]
then
    echo "Using default ~/$default_dropbox_path path for setup..."
else
    echo "Symlinking ~/$local_dropbox_path to ~/$default_dropbox_path..."
    ln -s $HOME/$default_dropbox_path $HOME/$local_dropbox_path
fi


###############################################################################
# Install Xcode command line tools
###############################################################################
echo "Installing Xcode Command Line Tools..."
xcode-select --install


###############################################################################
# Check for Homebrew, else install
###############################################################################
echo "Checking for Homebrew..."
if [ -z `command -v brew` ]
then
    echo "Brew is missing, installing it..."
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
    echo "Homebrew already installed., skipping..."
fi


###############################################################################
# Make sure we're on latest Homebrew
###############################################################################
echo "Homebrew: updating..."
brew update


###############################################################################
# Upgrade any already-installed formulae
###############################################################################
echo "Homebrew: upgrading..."
brew upgrade


###############################################################################
# Install binaries and other packages
###############################################################################
echo "Homebrew: installing utilities & packages..."
brew install bash-completion
brew install git
brew install autojump
brew cask install keepingyouawake
brew cask install alfred


###############################################################################
# Run Homebrew cleanup to remove installation/cached files
###############################################################################
echo "Homebrew: cleaning up..."
brew cleanup
