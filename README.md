# dotfiles-redux
Better (hopefully speedier) dotfiles. 

To use:

Include Git things in `~/.gitconfig`:

```bash
[include]
    path = ~/src/dotfiles-redux/.gitconfig
```


Include bash profile things in `~/.profile`:

```bash
source ~/src/dotfiles-redux/.sdubs_profile
source ~/src/dotfiles-redux/.better_profile
```
