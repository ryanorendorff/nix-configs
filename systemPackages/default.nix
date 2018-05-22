{ stdenv, lib, pkgs, chunkwm, ... }:

with pkgs; [
  aspell
  aspellDicts.en
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
  weechat
  wget
  youtube-dl
  zsh
]
  ++ lib.optionals stdenv.isDarwin ( callPackage ./darwin.nix {chunkwm = chunkwm;} )
  ++ lib.optionals stdenv.isLinux ( callPackage ./linux.nix {} )
