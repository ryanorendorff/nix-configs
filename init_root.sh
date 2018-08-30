#!/usr/bin/env bash

if [[ $(uname) != "Darwin" && $(whoami) == "root" ]]; then
  mkdir -p /etc/nixos
  if [[ ! -e /etc/nixos/configuration.nix ]] ; then
    ln -s `pwd`/configuration.nix /etc/nixos/configuration.nix
  fi
else
  echo "Please run this as root on a NixOS system."
fi
