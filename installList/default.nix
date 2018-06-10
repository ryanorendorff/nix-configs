{ lib, pkgs, config, ... }:

with pkgs; [
  ctags
  curl
  fasd
  fira-code
  flow
  font-awesome-ttf
  fzf
  gcalcli
  gettext
  git
  gnupg
  gnupg1compat
  hasklig
  haxor-news
  htop
  jq
  links2
  lsof
  mine.weechat
  mopidy
  mpc_cli
  ncdu
  ncmpc
  neomutt
  nix-repl
  nodejs
  openssl
  perl
  playerctl
  stow
  styx
  terraform
  tig
  typespeed
  urlview
  w3m
  wget
  youtube-dl
  zsh
]
  ++ lib.optionals pkgs.stdenv.isDarwin ( callPackage ./darwin.nix { config = config; } )
  ++ lib.optionals pkgs.stdenv.isLinux ( callPackage ./linux.nix { config = config; } )
