{ pkgs, ... }:

let
  myPythonPackages = pythonPackages: with pythonPackages; [
    websocket_client
  ];
  php = pkgs.php72;
  phpPackages = pkgs.php72Packages;
in
with pkgs; [
  (python.withPackages myPythonPackages)
  alarm-clock-applet
  apci
  bash-completion
  cava
  completiondmenu
  firefox-devedition-bin
  glibcLocales
  google-chrome
  i3
  i3blocks
  i3status
  jetbrains.phpstorm
  keepassx-community
  kpclie
  libnotify
  lm_sensors
  marp
  mpv
  openssh
  php71
  phpPackages.composer
  postman
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