#!/usr/bin/env bash

git submodule init
git submodule update

if [[ ! -d ~/.nixpkgs && $(uname) == "Darwin" ]] ; then
  mkdir -p ~/.nixpkgs
fi

if [[ ! -e ~/.nixpkgs/darwin-configuration.nix && $(uname) == "Darwin" ]] ; then
  ln -s `pwd`/darwin-configuration.nix ~/.nixpkgs/darwin-configuration.nix
fi

if [ ! -d ~/.config/nixpkgs ] ; then
  mkdir -p ~/.config/nixpkgs
fi

if [ ! -e ~/.config/nixpkgs/home.nix ] ; then
  ln -s `pwd`/home.nix ~/.config/nixpkgs/home.nix
fi

if [ ! -e ~/.config/nixpkgs/config.nix ] ; then
  ln -s `pwd`/config.nix ~/.config/nixpkgs/config.nix
fi

if [ ! -e ~/.zsh_custom ] ; then
  ln -s `pwd`/zsh/custom ~/.zsh_custom
fi
