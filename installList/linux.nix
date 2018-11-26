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
  mine.python36Packages.i3-gnome-pomodoro
  mine.postman
  mine.vr180-creator
  mpv
  networkmanagerapplet
  nixopsUnstable
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
