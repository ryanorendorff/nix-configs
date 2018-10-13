{ pkgs, lib, ... }:

let
  projectsPath = if pkgs.stdenv.isDarwin then "~/Projects" else "~/projects";
  downloadsVBoxPath = "/mnt/vbox/sdcard/Downloads";
  downloadsVmwarePath = "/mnt/vmware/downloads";
in pkgs.writeScript "personal_startup" (
  ''
    #!/usr/bin/env bash
    mkdir -p "${projectsPath}/nocoolnametom"

    # if [ ! -d "${projectsPath}/nocoolnametom/home-assistant-config" ]; then
    #   git clone git@github.com:nocoolnametom/home-assistant-config.git "${projectsPath}/nocoolnametom/home-assistant-config" ;
    # fi;

    if [ ! -d "${projectsPath}/nocoolnametom/cesletterbox" ]; then
      git clone git@github.com:nocoolnametom/cesletterbox.git "${projectsPath}/nocoolnametom/cesletterbox" ;
    fi;

    # if [ ! -d "${projectsPath}/nocoolnametom/my-blog" ]; then
    #   git clone git@github.com:nocoolnametom/my-blog.git "${projectsPath}/nocoolnametom/my-blog" ;
    # fi;

    if [ ! -d "${projectsPath}/nocoolnametom/nix-configs" ]; then
      git clone git@github.com:nocoolnametom/nix-configs.git "${projectsPath}/nocoolnametom/nix-configs" ;
    fi;

    if [ ! -d "${projectsPath}/nocoolnametom/wiki_copy" ]; then
      git clone git@github.com:nocoolnametom/wiki_copy.git "${projectsPath}/nocoolnametom/wiki_copy" ;
    fi;
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