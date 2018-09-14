# dotfiles-redux
Better (hopefully speedier) dotfiles.


## Prereqs

Install Dropbox and make sure Sync folder has finished syncing.

## How to use

Run push script:

```shell
./pu.sh
```

This will do the following:
- Set up dev and Dropbox folder locations
- Install Homebrew and useful packages
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
2. [Symlink User folder](https://packagecontrol.io/docs/syncing) from Dropbox


## iTerm Setup

1. Enable 'Load preferences from a custom folder or URL:'
2. Choose the `iterm` folder from Dropbox


# TODO

- [x] Write a script to do install * symlinking automatically.
- [x] Figure out autocompletion
