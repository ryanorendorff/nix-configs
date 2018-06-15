{ prefix ? "", pkgs, ... }:

{
  "${prefix}rtv/rtv.cfg" = {
    source = pkgs.appConfigs.rtv;
  };
}