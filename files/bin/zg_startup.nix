{ prefix ? "", pkgs, ... }:

{
  "${prefix}zg_startup" = {
    source = pkgs.mine.scripts.zg_startup;
    executable = true;
  };
}