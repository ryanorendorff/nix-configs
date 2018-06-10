{ pkgs, lib, ... }:

let
  projectsPath = if pkgs.stdenv.isDarwin then "~/Projects/" else "~/projects/";
  downloadsVBoxPath = "/mnt/vbox/sdcard/Downloads";
  downloadsVmwarePath = "/mnt/vmware/downloads";
in ''
  #!/usr/bin/env bash
  mkdir -p ${projectsPath}{fluent,nocoolnametom}

  if [ ! -d ${projectsPath}fluent/es6-react-pres ]; then
    git clone https://github.com/btholt/es6-react-pres.git ${projectsPath}fluent/es6-react-pres ;
  fi;

  if [ ! -d ${projectsPath}nocoolnametom/cesletter ]; then
    git clone git@github.com-nocoolnametom:nocoolnametom/cesletter.git ${projectsPath}nocoolnametom/cesletter ;
  fi;

  if [ ! -d ${projectsPath}nocoolnametom/cesletterbox ]; then
    git clone git@github.com-nocoolnametom:nocoolnametom/cesletterbox.git ${projectsPath}nocoolnametom/cesletterbox ;
  fi;

  if [ ! -d ${projectsPath}nocoolnametom/nixpkgs ]; then
    git clone git@github.com-nocoolnametom:nocoolnametom/nixpkgs.git ${projectsPath}nocoolnametom/nixpkgs ;
  fi;

  if [ ! -d ${projectsPath}nocoolnametom/wiki_copy ]; then
    git clone git@github.com-nocoolnametom:nocoolnametom/wiki_copy.git ${projectsPath}nocoolnametom/wiki_copy ;
  fi;
'' + (
  if pkgs.stdenv.isDarwin then "" else ''
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