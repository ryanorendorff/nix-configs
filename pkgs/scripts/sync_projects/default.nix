{ pkgs, config, ... }:

let
  vars = {
    backup-script = pkgs.mine.scripts.zg_backup;
    rsync-options = "-qa --no-links --no-perms --no-owner --no-group --delete";
    source = "${pkgs.my.directories.projects}/backup";
  } // (if pkgs.stdenv.isLinux then {
    destination = "${pkgs.my.directories.home}/google_drive/projects/";
  } else {
    destination = "/Volumes/GoogleDrive/My Drive/projects/backup/";
  });
in pkgs.writeScript "sync_projects" ''
  #!/usr/bin/env bash
  ${vars.backup-script} && rsync ${vars.rsync-options} "${vars.source}" "${vars.destination}"
''
