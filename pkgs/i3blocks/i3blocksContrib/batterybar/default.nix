{ pkgs, mkI3blockContribScript, ... }:

mkI3blockContribScript {
  scriptName = "batterybar";
  buildDeps = [ pkgs.acpi ];
}