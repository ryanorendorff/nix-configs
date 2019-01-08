{ pkgs, config, sharedPythonPackages ? [], ... }:

let
  myPythonPackages = pythonPackages: with pythonPackages; [
  ] ++ sharedPythonPackages;
  php = pkgs.php72;
  phpPackages = pkgs.php72Packages;
in
with pkgs; [
  (python.withPackages myPythonPackages)
  bash-completion
  blueman
  # bluejeans
  cava
  compton
  dmenu
  glibcLocales
  gnome3.pomodoro # This is a dependency for i3-gnome-pomodoro-mine; need to get it as part of the derivation
  gnupg
  gnupg1compat
  google-play-music-desktop-player
  i3
  i3blocks
  i3status
  insync
  jetbrains.phpstorm
  jmtpfs
  keepassxc
  keybase
  kpcli
  libnotify
  lm_sensors
  marp
  mcomix
  mine.python3Packages.i3-gnome-pomodoro
  mine.python3Packages.kindle-comic-converter
  mine.postman
  mine.vr180-creator
  mpv
  networkmanagerapplet
  nixopsUnstable
  openssh
  php71
  phpPackages.composer
  playerctl
  qscreenshot
  slack
  sysstat
  termite
  vit
  vlc
  vscode
  whois
  xautolock
  xterm
]
