#!/usr/bin/env bash

export PWD=`pwd`;

if [[ $(uname) == "Darwin" ]]; then
  mkdir -p ~/.nixpkgs
  if [[ ! -e ~/.nixpkgs/darwin-configuration.nix ]] ; then
    ln -s "$PWD/darwin-configuration.nix" ~/.nixpkgs/darwin-configuration.nix
  fi
fi

if [[ -z "$XDG_CONFIG_HOME" ]]; then
  export XDG_CONFIG_HOME=~/.config
fi

mkdir -p "$XDG_CONFIG_HOME/nixpkgs"

# Ensure all private files exist even if they're not valid
if [ ! -e "$XDG_CONFIG_HOME/nixpkgs/home.nix" ] ; then
  ln -s "$PWD/home.nix" "$XDG_CONFIG_HOME/nixpkgs/home.nix"
fi

if [ ! -e "$XDG_CONFIG_HOME/nixpkgs/config.nix" ] ; then
  ln -s "$PWD/config.nix" "$XDG_CONFIG_HOME/nixpkgs/config.nix"
fi

if [ ! -e "$PWD/keys/private/credentials.json" ] ; then
  echo "{}" >> "$PWD/keys/private/credentials.json"
fi

if [ ! -e "$PWD/keys/private/token.json" ] ; then
  echo "{}" >> "$PWD/keys/private/token.json"
fi

if [ ! -e "$PWD/keys/private/google_mopidy_key.nix" ] ; then
  echo '""' >> "$PWD/keys/private/google_mopidy_key.nix"
fi

if [ ! -e "$PWD/keys/private/jenkins_api_key.nix" ] ; then
  echo '""' >> "$PWD/keys/private/jenkins_api_key.nix"
fi

if [ ! -e "$PWD/keys/private/longview_api_key.nix" ] ; then
  echo '""' >> "$PWD/keys/private/longview_api_key.nix"
fi

if [ ! -e "$PWD/keys/private/openweathermap_key.nix" ] ; then
  echo '""' >> "$PWD/keys/private/openweathermap_key.nix"
fi

if [ ! -e "$PWD/keys/private/todoist_key.nix" ] ; then
  echo '""' >> "$PWD/keys/private/todoist_key.nix"
fi

if [ ! -e "$PWD/keys/private/id_rsa" ] ; then
  touch "$PWD/keys/private/id_rsa"
fi

if [ ! -e "$PWD/keys/private/mysqlaccess" ] ; then
  touch "$PWD/keys/private/mysqlaccess"
fi

if [ ! -e "$PWD/keys/private/stage-apops" ] ; then
  touch "$PWD/keys/private/stage-apops"
fi

if [ ! -e "$PWD/keys/private/trulia_rsa" ] ; then
  touch "$PWD/keys/private/trulia_rsa"
fi

git update-index --skip-worktree mutableDotfiles/weechat/.weechat/sec.conf