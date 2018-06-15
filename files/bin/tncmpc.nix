{ prefix ? "", pkgs, ... }:

{
  "${prefix}tncmpc" = {
    source = pkgs.mine.scripts.tncmpc;
    executable = true;
  };
}