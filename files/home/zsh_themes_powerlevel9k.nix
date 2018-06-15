{ prefix ? "", pkgs, ... }:

{
  "${prefix}.zsh_custom/themes/powerlevel9k" = {
    source = pkgs.mine.powerlevel9k;
  };
}