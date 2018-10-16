{ prefix ? "", pkgs, ... }:

{
  "${prefix}personalgitclone" = {
    source = pkgs.mine.scripts.personalgitclone;
    executable = true;
  };
}