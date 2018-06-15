{ prefix ? "", pkgs, ... }:

{
  "${prefix}zgitclone" = {
    source = pkgs.mine.scripts.zgitclone;
    executable = true;
  };
}