{ prefix ? "", pkgs, ... }:

{
  "${prefix}chrome-personal" = {
    source = pkgs.mine.scripts.chrome-personal;
    executable = true;
  };
}