{ prefix ? "", pkgs, ... }:

{
  "${prefix}thtop" = {
    source = pkgs.mine.scripts.thtop;
    executable = true;
  };
}