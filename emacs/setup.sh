#!/bin/bash

DEFAULT_LOCATION="$HOME/.emacs"
if [ -L $DEFAULT_LOCATION ]; then
  read -p "Do you wish to remove existing configuration? (y/n) " yn
  case $yn in
      [Yy]* ) rm "$DEFAULT_LOCATION";;
      [Nn]* ) exit;;
      * ) exit;;
  esac
else
  echo "existing configuration not found"
fi

# Soft link to default location of init file
ln -s $(pwd)/init.el $DEFAULT_LOCATION