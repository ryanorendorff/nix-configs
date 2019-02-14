{ prefix ? "", pkgs, ... }:

{
  "${prefix}ap/ap_handles.json" = {
    source = pkgs.callPackage ./ap_handles.nix {};
  };
}
