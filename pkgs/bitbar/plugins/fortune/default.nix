{ pkgs, mkBitbarPluginFromMainGithub, ... }:

mkBitbarPluginFromMainGithub {
  category = "Lifestyle";
  baseName = "fortune";
  fileExtension = "5m.sh";
  inputs = [ ];
}