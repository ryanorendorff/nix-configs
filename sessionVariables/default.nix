{ pkgs, lib ? pkgs.lib, vim ? pkgs.vim, ... }:

let
  projectsDir = (builtins.getEnv "HOME") + (if pkgs.stdenv.isDarwin then "/Projects" else "/projects");
in (
  rec {
    # NixOS Auto-installs a program when called, temporarily
    NIX_AUTO_RUN = "1";
    # Background Color Fix for Mutt
    COLORFGBG = "default;default";
    # Unified Variables
    PAGER = "less";
    TERM = "xterm-256color";
    RTV_EDITOR = "vim";
    RTV_URLVIEWER = "${pkgs.urlview}/bin/urlview";
    PROJECTS = projectsDir;
    DOTFILES = "${PROJECTS}/nocoolnametom/dotfiles";
    ZILLOW = "${PROJECTS}/zillow";
  }
  // (lib.mkIf pkgs.stdenv.isDarwin (import ./darwin.nix { inherit pkgs; inherit vim; }))
  // (lib.mkIf pkgs.stdenv.isLinux  (import ./linux.nix  { inherit pkgs; inherit vim; }))
)