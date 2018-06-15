{ prefix ? "", pkgs, ... }:

{
  "${prefix}tweechat" = {
    source = pkgs.mine.scripts.tweechat;
    executable = true;
  };
}