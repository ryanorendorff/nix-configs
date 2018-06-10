{ lib, pkgs, config, ... }:

let variables = (
  {
    # NixOS Auto-installs a program when called, temporarily
    NIX_AUTO_RUN = "1";
    # Background Color Fix for Mutt
    COLORFGBG = "default;default";
    # Unified Variables
    PAGER = "less";
    TERM = "xterm-256color";
  }
  // (if pkgs.stdenv.isDarwin then import ./darwin.nix { pkgs = pkgs; } else {})
  // (if pkgs.stdenv.isLinux then import ./linux.nix { pkgs = pkgs; config = config; } else {})
); in {
  variables = variables;
}
