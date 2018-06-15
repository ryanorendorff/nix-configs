{ prefix ? "", pkgs, ... }:

{
  "${prefix}trtv" = {
    source = pkgs.mine.scripts.trtv;
    executable = true;
  };
}