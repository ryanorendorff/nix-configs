{ prefix ? "", pkgs, ... }:

{
  "${prefix}trulia/db_handles.json" = {
    source = pkgs.callPackage ./db_handles_file {};
  };
}
