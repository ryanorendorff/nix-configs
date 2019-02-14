{ pkgs, options, config, lib, ... }:

let
  homeDirectory = if (lib.hasAttrByPath ["home" "homeDirectory"] config) then config.home.homeDirectory else "~";
  addHomeFiles = pkgs.callPackage ../addHomeFiles.nix {};
  addConfigFiles = pkgs.callPackage ../addConfigFiles.nix {};
  addDataFiles = pkgs.callPackage ../addDataFiles.nix {};
  dagEntry = pkgs.callPackage ../dagEntry.nix {};
  mutableDotfiles = toString ../../mutableDotfiles;
in (lib.mkIf pkgs.stdenv.isDarwin {
  programs.bash.enable = false;
  programs.feh.enable = false;
  programs.vim.enable = false;
  programs.termite.enable = false;
  programs.zsh.enable = false;
  xsession.enable = false;
  # services.xscreensaver = false;

  home.file = addHomeFiles pkgs.myFiles [
    pkgs.myFiles.bitbar.calendar
    pkgs.myFiles.bitbar.google_music
    pkgs.myFiles.bitbar.chunkwm_skhd
  ];

  xdg.configFile = addConfigFiles pkgs.myFiles [];

  xdg.dataFile = addDataFiles pkgs.myFiles [
    pkgs.myFiles.xdg.first_run
  ];

  home.activation.tomDoggettInitDarwin = dagEntry.after ["tomDoggettInit"] ''
    mkdir -p ${mutableDotfiles}/weechat-plugins/.weechat/python
    cp -fL ${pkgs.mine.weechatPlugins.notification_center}/notification_center.py ${mutableDotfiles}/weechat-plugins/.weechat/python/notification_center.py
    stow -d "${mutableDotfiles}" -t ${homeDirectory} vscode_macos vscode_fix_symlinks_macos
  '';
})
