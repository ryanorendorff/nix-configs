{ pkgs, lib ? pkgs.lib, ... }:

let
  dagEntry = pkgs.callPackage ./dagEntry.nix {};
in {
  home.activation.tomDoggettInitVerifyRepos = dagEntry.after ["tomDoggettInit"] ''
    ${pkgs.mine.scripts.zg_startup}
    ${pkgs.mine.scripts.personal_startup}
  '';
}
