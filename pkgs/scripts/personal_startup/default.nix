{ pkgs, lib, ... }:

let
  downloadsVBoxPath = "/mnt/vbox/sdcard/Downloads";
  downloadsVmwarePath = "/mnt/vmware/downloads";
in pkgs.writeScript "personal_startup" (
  ''
    #!/usr/bin/env bash
    ${pkgs.mine.scripts.personal_repos}
  '' + (
    lib.optionalString (!pkgs.stdenv.isDarwin) ''
      if [[ ! -L ~/Downloads && -d ${downloadsVBoxPath} ]]; then
        if [ -d ~/Downloads ]; then
          mv ~/Downloads ~/Downloads.orig
        fi
        ln -s ${downloadsVBoxPath} ~/Downloads ;
      fi

      if [[ ! -L ~/Downloads && -d ${downloadsVmwarePath} ]]; then
        if [ -d ~/Downloads ]; then
          mv ~/Downloads ~/Downloads.orig
        fi
        ln -s ${downloadsVmwarePath} ~/Downloads ;
      fi
    ''
  )
)
