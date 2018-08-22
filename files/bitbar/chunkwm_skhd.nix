{ prefix ? "", pkgs, ... }:

{
  "${prefix}chunkwm_skhd.1s.sh" = {
    source = pkgs.mine.bitbar.mine.chunkwm_skhd;
    executable = true;
  };
}