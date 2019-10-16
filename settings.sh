#!/bin/bash

echo "Symlinking settings..."

settings_path="${HOME}/Dropbox/Sync"

# echo $settings_path

# Sublime

subl_src="$settings_path/sublime/User"
subl_dest="~/Library/Application Support/Sublime Text 3/Packages/User"

echo $subl_dest

# this is wonky and won't remove if symlink
rm -rf "$subl_dest"
# echo `ln -s "$subl_src $subl_dest"`

# Karabiner

karabiner_src="$settings_path/karabiner"
karabiner_dest="~/.config/karabiner"

echo $karabiner_src
echo $karabiner_dest

# rm -rf "$karabiner_dest"
# ln -s "$karabiner_src $karabiner_dest"

#Alfred
# echo "Enter powerpack license and enable synced settings in Alfred Preferences"
