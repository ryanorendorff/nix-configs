#!/usr/bin/env bash

if [[ $(uname) == "Darwin" ]]; then
  mkdir -p ~/.nixpkgs
  if [[ ! -e ~/.nixpkgs/darwin-configuration.nix ]] ; then
    ln -s `pwd`/darwin-configuration.nix ~/.nixpkgs/darwin-configuration.nix
  fi
fi

if [[ -z "$XDG_CONFIG_HOME" ]]; then
  export XDG_CONFIG_HOME=~/.config
fi

mkdir -p "$XDG_CONFIG_HOME/nixpkgs"

if [ ! -e "$XDG_CONFIG_HOME/nixpkgs/home.nix" ] ; then
  ln -s `pwd`/home.nix "$XDG_CONFIG_HOME/nixpkgs/home.nix"
fi

if [ ! -e "$XDG_CONFIG_HOME/nixpkgs/config.nix" ] ; then
  ln -s `pwd`/config.nix "$XDG_CONFIG_HOME/nixpkgs/config.nix"
fi

git update-index --skip-worktree mutableDotfiles/weechat/.weechat/sec.conf