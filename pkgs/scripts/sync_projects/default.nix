{ pkgs, config, ... }:

let
  vars = {
    backup-script = pkgs.mine.scripts.zg_backup;
    rsync-options = "-qa --no-links --no-perms --no-owner --no-group --delete";
    source = "${builtins.getEnv "PROJECTS"}/backup";
  } // (if pkgs.stdenv.isLinux then {
    destination = "/mnt/vmware/googledrive/projects/";
  } else {
    destination = "/Volumes/GoogleDrive/My Drive/projects/backup/";
  });
in pkgs.writeScript "sync_projects" ''
  #!/usr/bin/env bash
  ${vars.backup-script} && rsync ${vars.rsync-options} "${vars.source}" "${vars.destination}"
''