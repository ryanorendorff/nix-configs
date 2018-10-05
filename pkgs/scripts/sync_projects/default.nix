{ pkgs, config, ... }:

let
  vars = {
    backup-script = pkgs.mine.scripts.zg_backup;
    rsync-options = "-qa --no-links --no-perms --no-owner --no-group --delete";
  } // (if pkgs.stdenv.isLinux then {
    destination = "/home/tdoggett/google_drive/projects/";
    source = "/home/tdoggett/projects/backup";
  } else {
    destination = "/Volumes/GoogleDrive/My Drive/projects/backup/";
    source = "/Users/tdoggett/Projects/backup";
  });
in pkgs.writeScript "sync_projects" ''
  #!/usr/bin/env bash
  ${vars.backup-script} && rsync ${vars.rsync-options} "${vars.source}" "${vars.destination}"
''