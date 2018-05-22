{ pkgs, mine, ... }:

let
  myPythonPackages = pythonPackages: with pythonPackages; [
    websocket_client
  ];
  php = pkgs.php72;
  phpPackages = pkgs.php72Packages;
in
with pkgs; [
  (python.withPackages myPythonPackages)
  mine.i3-gnome-pomodoro-mine
  mine.postman-mine
  alarm-clock-applet
  apci
  bash-completion
  cava
  completiondmenu
  compton
  dmenu
  firefox-devedition-bin
  glibcLocales
  gnome3.pomodoro
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
  postman
  qscreenshot
  rtv
  sysstat
  termite
  vim
  vit
  vlc
  vscode
  whois
  xautolock
  xterm
]