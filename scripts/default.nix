{ stdenv, pkgs, config, ... }:

let
  files = pkgs.callPackage ../files {};
in (
  {
    "bin/zg_startup" = {
      text = pkgs.callPackage ./zg_startup {
        zgitclone = "${builtins.getEnv "HOME"}/${config.home.file."bin/zgitclone".target}";
      };
      executable = true;
    };
    "bin/zg_backup" = {
      text = pkgs.callPackage ./zg_backup { };
      executable = true;
    };
    "bin/zgitclone" = {
      text = pkgs.callPackage ./zgitclone { };
      executable = true;
    };
    ".ideavimrc" = {
      text = files.ideavimrc;
      executable = false;
    };
    ".config/rtv/rtv.cfg" = {
      text = files.rtv-cfg;
      executable = false;
    };
    ".muttrc" = {
      text = files.muttrc;
      executable = false;
    };
  }
  // (if stdenv.isDarwin then import ./darwin.nix { pkgs = pkgs; config = config; } else {})
  // (if stdenv.isLinux then import ./linux.nix { pkgs = pkgs; config = config; } else {})
)