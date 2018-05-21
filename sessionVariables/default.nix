{ lib, stdenv, pkgs, nvim, ... }:

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
  // (if stdenv.isDarwin then import ./darwin.nix { pkgs = pkgs; nvim = nvim; } else {})
  // (if stdenv.isLinux then import ./linux.nix { pkgs = pkgs; nvim = nvim; } else {})
); in {
  variables = variables;
}