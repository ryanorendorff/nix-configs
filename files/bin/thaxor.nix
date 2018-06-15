{ prefix ? "", pkgs, ... }:

{
  "${prefix}thaxor" = {
    source = pkgs.mine.scripts.thaxor;
    executable = true;
  };
}