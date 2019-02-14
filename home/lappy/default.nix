{ pkgs, lib ? pkgs.lib, config, ... }:

let
  isLappy = true; # Need to figure out a way to determine the lappy vs. raspi vs. desktop environment...
  homeDirectory = if (lib.hasAttrByPath ["home" "homeDirectory"] config) then config.home.homeDirectory else "~";
  addHomeFiles = pkgs.callPackage ../addHomeFiles.nix {};
  addConfigFiles = pkgs.callPackage ../addConfigFiles.nix {};
  addDataFiles = pkgs.callPackage ../addDataFiles.nix {};
  dagEntry = pkgs.callPackage ../dagEntry.nix {};
  mutableDotfiles = toString ../mutableDotfiles;
in (lib.mkIf pkgs.stdenv.isLinux {
  programs.bash.enable = true;
  programs.feh.enable = true;
  programs.firefox.enable = true;
  programs.go.enable = true;
  programs.vim.enable = true;
  programs.termite.enable = true;
  programs.zsh.enable = true;
  xsession.enable = true;
  xsession.windowManager.i3.enable = true;

  services.compton.enable = true;
  services.dunst.enable = true;
  services.gpg-agent.enable = true;
  services.keybase.enable = true;
  services.kbfs.enable = true;
  services.network-manager-applet.enable = true;
  # services.random-background.enable = true;
  services.redshift.enable = true;
  services.screen-locker.enable = false;
  services.unclutter.enable = true;
  services.xscreensaver.enable = true;

  home.file = addHomeFiles pkgs.myFiles [
    pkgs.myFiles.home.mailcap
  ];

  xdg.configFile = addConfigFiles pkgs.myFiles [
    pkgs.myFiles.xdg.i3blocks
  ];

  xdg.dataFile = addDataFiles pkgs.myFiles [];

  home.activation.tomDoggettInitLinux = dagEntry.after ["tomDoggettInit"] ''
    cp -fL ${pkgs.mine.weechatPlugins.notify_send}/notify_send.py ${mutableDotfiles}/weechat-plugins/.weechat/python/notify_send.py
    stow -d "${mutableDotfiles}" -t ${homeDirectory} vscode vscode_fix_symlinks
  '';


})
