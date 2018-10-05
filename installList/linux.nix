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
  cava
  compton
  dmenu
  firefox
  glibcLocales
  gnome3.pomodoro # This is a dependency for i3-gnome-pomodoro-mine; need to get it as part of the derivation
  gnupg
  gnupg1compat
  i3
  i3blocks
  i3status
  jetbrains.phpstorm
  keepassx-community
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
