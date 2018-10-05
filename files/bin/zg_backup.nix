{ prefix ? "", pkgs, ... }:

{
  "${prefix}zg_backup" = {
    source = pkgs.mine.scripts.zg_backup;
    executable = true;
  };
}