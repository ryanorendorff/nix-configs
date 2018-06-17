{ pkgs, config, ... }:

let
  myPythonPackages = pythonPackages: with pythonPackages; [
  ];
  php = pkgs.php72;
  phpPackages = pkgs.php72Packages;
in
with pkgs; [
  (python.withPackages myPythonPackages)
  bash-completion
  cava
  compton
  dmenu
  glibcLocales
  gnome3.pomodoro # This is a dependency for i3-gnome-pomodoro-mine; need to get it as part of the derivation
  gnupg
  gnupg1compat
  google-chrome
  i3
  i3blocks
  i3status
  jetbrains.phpstorm
  keepassx-community
  kpcli
  libnotify
  lm_sensors
  marp
  mine.python36Packages.i3-gnome-pomodoro
  mine.postman
  mine.vr180-creator
  mpv
  openssh
  php71
  phpPackages.composer
  qscreenshot
  rtv
  sysstat
  termite
  vit
  vlc
  vscode
  whois
  xautolock
  xterm
]
