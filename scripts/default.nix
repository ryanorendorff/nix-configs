{ pkgs, config, ... }:

let
  files = pkgs.callPackage ../files { inherit config; };
  theScripts = (
    {
      "bin/personal_startup" = {
        text = pkgs.callPackage ./personal_startup { inherit config; };
        executable = true;
      };
      "bin/zg_startup" = {
        text = pkgs.callPackage ./zg_startup {
          inherit config;
          zgitclone = "${builtins.getEnv "HOME"}/${config.home.file."bin/zgitclone".target}";
        };
        executable = true;
      };
      "bin/zg_backup" = {
        text = pkgs.callPackage ./zg_backup { inherit config; };
        executable = true;
      };
      "bin/zgitclone" = {
        text = pkgs.callPackage ./zgitclone { inherit config; };
        executable = true;
      };
      "bin/sync_projects" = {
        text = pkgs.callPackage ./sync_projects { inherit config; };
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
      ".npmrc" = {
        text = files.npmrc;
        executable = false;
      };
      ".muttrc" = {
        text = files.muttrc;
        executable = false;
      };
      ".zsh_custom/themes/powerlevel9k" = {
        source = pkgs.mine.powerlevel9k;
        executable = false;
      };
    }
    // (if pkgs.stdenv.isDarwin then import ./darwin.nix { inherit pkgs; inherit config; } else {})
    // (if pkgs.stdenv.isLinux then import ./linux.nix { inherit pkgs; inherit config; } else {})
  );
in {
  inherit theScripts;
}