{ prefix ? "", pkgs, ... }:

{
  "${prefix}tmutt" = {
    source = pkgs.mine.scripts.tmutt;
    executable = true;
  };
}