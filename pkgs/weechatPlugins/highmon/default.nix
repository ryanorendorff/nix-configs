{ pkgs, mkWeechatPluginFromMainGithub, ... }:

mkWeechatPluginFromMainGithub {
  lang = "perl";
  baseName = "highmon";
  inputs = [ pkgs.perl ];
}