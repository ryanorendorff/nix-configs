{ pkgs, lib, ... }:

let
  projectsPath = if pkgs.stdenv.isDarwin then "~/Projects" else "~/projects";
  downloadsVBoxPath = "/mnt/vbox/sdcard/Downloads";
  downloadsVmwarePath = "/mnt/vmware/downloads";
  nocoolnametomProjects = [
    "cesletterbox"
    # "home-assistant-config"
    "nix-configs"
    "wiki_copy"
  ];
in pkgs.writeScript "personal_startup" (
  ''
    #!/usr/bin/env bash
    mkdir -p ${projectsPath}/nocoolnametom

    for REPO in ${lib.concatStrings (lib.concatMap (x: ["\""] ++ [x] ++ ["\""] ++ [" "]) nocoolnametomProjects)}; do
      if [ ! -d ${projectsPath}/nocoolnametom/$REPO ]; then
        git clone github.com:nocoolnametom/$REPO.git ${projectsPath}/nocoolnametom/$REPO ;
      fi;
    done
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