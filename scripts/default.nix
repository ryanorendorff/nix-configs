{ pkgs, config, ... }:

let
  files = pkgs.callPackage ../files { inherit config; };
  theScripts = (
    {
      "bin/personal_startup" = {
        source = pkgs.mine.scripts.personal_startup;
        executable = true;
      };
      "bin/zg_startup" = {
        source = pkgs.mine.scripts.zg_startup;
        executable = true;
      };
      "bin/zg_backup" = {
        source = pkgs.mine.scripts.zg_backup;
        executable = true;
      };
      "bin/zgitclone" = {
        source = pkgs.mine.scripts.zgitclone;
        executable = true;
      };
      "bin/sync_projects" = {
        source = pkgs.mine.scripts.sync_projects;
        executable = true;
      };
      ".ideavimrc" = {
        text = files.ideavimrc;
        executable = false;
      };
      ".config/rtv/rtv.cfg" = {
        text = pkgs.appConfigs.rtv;
        executable = false;
      };
      ".npmrc" = {
        text = files.npmrc;
        executable = false;
      };
      ".muttrc" = {
        source = pkgs.appConfigs.neomutt;
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