#!/usr/bin/env bash

if [ ! -d ~/.nixpkgs ] ; then
  mkdir -p ~/.nixpkgs
fi

if [ ! -e ~/.nixpkgs/darwin-configuration.nix ] ; then
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
