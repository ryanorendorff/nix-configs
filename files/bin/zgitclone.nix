{ prefix ? "", pkgs, ... }:

{
  "${prefix}personal_startup" = {
    source = pkgs.mine.scripts.personal_startup;
    executable = true;
  };
}