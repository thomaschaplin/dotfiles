# dotfiles

This repository contains my personal dotfiles.

This repo should be used using the `--bare` flag with git.

## Setup

This is a loose guide as I've never run the setup before, something to update when I setup a new machine. This is all assumptions - some steps might need updating.

- Change directory to `$HOME` or `~`
- Run `mkdir $HOME/dotfiles`
- Add `alias config='/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME'` to your `.zshrc` or `.bashrc` file
- Run `config config --local status.showUntrackedFiles no`
- Clone the repository - `git clone --bare git@github.com:thomaschaplin/dotfiles.git $HOME/dotfiles`

If running macOS (or Linux) then you will need to run `brew bundle install` which will use the `Brewfile`

## Basic Usage

```
config add /path/to/file
config commit -m "A short message"
config push
```

## Miscellaneous

Helpful links:

- [Dotfiles Blog](https://www.atlassian.com/git/tutorials/dotfiles)
- [YouTube Tutorial](https://www.youtube.com/watch?v=tBoLDpTWVOM)

