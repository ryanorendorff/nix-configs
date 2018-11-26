{ lib, pkgs, config, ... }:

with pkgs;
with {
  sharedPythonPackages = [
    # pkgs.mine.python27Packages.apopscli
  ];
};
[
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
  mine.wtfutil
  mpc_cli
  ncdu
  ncmpc
  neomutt
  nodejs
  openssl
  perl
  playerctl
  silver-searcher
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
  ++ lib.optionals pkgs.stdenv.isDarwin ( callPackage ./darwin.nix { inherit config; inherit sharedPythonPackages; } )
  ++ lib.optionals pkgs.stdenv.isLinux ( callPackage ./linux.nix { inherit config; inherit sharedPythonPackages; } )
