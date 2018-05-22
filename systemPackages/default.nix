{ stdenv, lib, pkgs, chunkwm, config, ... }:

let
  mine = pkgs.callPackage ./mine {};
in with pkgs; [
  mine.weechat-with-slack
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
  terraform
  tig
  typespeed
  urlview
  w3m
  wget
  youtube-dl
  zsh
]
  ++ lib.optionals stdenv.isDarwin ( callPackage ./darwin.nix {mine = mine; chunkwm = chunkwm;} )
  ++ lib.optionals stdenv.isLinux ( callPackage ./linux.nix { mine = mine; config = config; } )
