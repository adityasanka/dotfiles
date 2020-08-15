#!/bin/sh

# TODO: What do we do when directory already exists
mkdir -p ~/.emacs.d

# Copy a elisp snippet that links config to dotfiles
cat symlink.el >> ~/.emacs.d/init.el
