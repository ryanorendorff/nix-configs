{ pkgs, ... }:

"0 * * * * ${pkgs.my.username} ${pkgs.mine.scripts.sync_projects}"
