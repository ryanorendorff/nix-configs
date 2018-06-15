{ prefix ? "", pkgs, ... }:

{
  "${prefix}youtube" = {
    source = pkgs.mine.scripts.youtube;
    executable = true;
  };
}