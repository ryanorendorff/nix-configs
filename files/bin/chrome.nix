{ prefix ? "", pkgs, ... }:

{
  "${prefix}chrome" = {
    source = pkgs.mine.scripts.chrome;
    executable = true;
  };
}