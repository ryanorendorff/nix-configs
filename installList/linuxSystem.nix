{ pkgs, config, sharedPythonPackages ? [], ... }:

let
  myPythonPackages = pythonPackages: with pythonPackages; [
  ] ++ sharedPythonPackages;
in
with pkgs; [
  wget
  rsync
  tmux
  screen
  mopidy
  unzip
  glibcLocales
  gitAndTools.gitFull
  gitAndTools.git-extras
  vim
  nodejs-8_x
]
