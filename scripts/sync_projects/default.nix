{ pkgs, config, ... }:

let
  vars = {
    backup-script = "${config.home.homeDirectory}/${config.home.file."bin/zg_backup".target}";
    rsync-options = "-qa --no-links --no-perms --no-owner --no-group --delete";
    source = "${builtins.getEnv "PROJECTS"}/backup";
  } // (if pkgs.stdenv.isLinux then {
    destination = "/mnt/vmware/googledrive/projects/";
  } else {
    destination = "/Volumes/GoogleDrive/My Drive/projects/backup/";
  });
in
''
  #!/usr/bin/env bash
  ${vars.backup-script} && rsync ${vars.rsync-options} "${vars.source}" "${vars.destination}"
''