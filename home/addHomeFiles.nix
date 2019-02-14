{ pkgs, lib ? pkgs.lib, ... }:

myFiles: newFiles: lib.mkMerge([
  myFiles.bin.personal_startup
  myFiles.bin.personalgitclone
  myFiles.bin.personal_repos
  myFiles.bin.sync_projects
  myFiles.bin.zg_backup
  myFiles.bin.zg_startup
  myFiles.bin.zgitclone
  myFiles.home.ideavim
  myFiles.home.muttrc
  myFiles.home.npmrc
  myFiles.home.wtfutil_gcal_token
  myFiles.home.zsh_themes_powerlevel9k
] ++ newFiles)
