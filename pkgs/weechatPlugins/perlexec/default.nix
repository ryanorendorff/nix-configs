{ pkgs, mkWeechatPluginFromMainGithub, ... }:

mkWeechatPluginFromMainGithub {
  lang = "perl";
  baseName = "perlexec";
  inputs = [ pkgs.perl ];
}