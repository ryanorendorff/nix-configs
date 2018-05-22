{ pkgs, mine, config, ... }:

let
  myPythonPackages = pythonPackages: with pythonPackages; [
  ];
  php = pkgs.php72;
  phpPackages = pkgs.php72Packages;
in
with pkgs; [
  (python.withPackages myPythonPackages)
  mine.i3-gnome-pomodoro-mine
  gnome3.pomodoro # This is a dependency for i3-gnome-pomodoro-mine; need to get it as part of the derivation
  mine.postman-mine
  alarm-clock-applet
  bash-completion
  cava
  compton
  dmenu
  firefox-devedition-bin
  glibcLocales
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