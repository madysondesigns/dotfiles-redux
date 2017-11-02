# dotfiles-redux
Better (hopefully speedier) dotfiles. 

## Things to install

Prerequisites:
- Homebrew: 

```shell
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```
- Git: 

```shell
brew install git
```

Useful things:
- Autojump
- NPM
- rbenv
- hub


## How to use

Run push script:

```shell
./pu.sh
```

This will do the following: 
- Back up any dotfiles if they existed prior to running this
- Create `.bash_profile` master dotfile (if it doesn't exist)
- Create `.work_profile` for work-specific config (if it doesn't exist)
- Create symlinks to config files in this repo
- Source custom profiles into master dotfile
- Add custom git configuration
- Add `subl` command


After running the script, you'll need to manually set up Sublime and iTerm pref syncing. 


## Sublime Setup

1. Install [Package Control](https://packagecontrol.io/installation)
2. [Symlink User folder](https://packagecontrol.io/docs/syncing)


## iTerm Setup

1. Enable 'Load preferences from a custom folder or URL:'
2. Choose the `iterm` folder in this repo


# TODO

- [x] Write a script to do install * symlinking automatically.
- [x] Figure out autocompletion
