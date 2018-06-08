#!/usr/bin/env bash

if [[ $(uname) == "Darwin" ]]; then
  mkdir -p ~/.nixpkgs
  if [[ ! -e ~/.nixpkgs/darwin-configuration.nix ]] ; then
    ln -s `pwd`/darwin-configuration.nix ~/.nixpkgs/darwin-configuration.nix
  fi
fi

mkdir -p ~/.config/nixpkgs

if [ ! -e ~/.config/nixpkgs/home.nix ] ; then
  ln -s `pwd`/home.nix ~/.config/nixpkgs/home.nix
fi

if [ ! -e ~/.config/nixpkgs/config.nix ] ; then
  ln -s `pwd`/config.nix ~/.config/nixpkgs/config.nix
fi
