{ pkgs, mkWeechatPluginFromMainGithub, ... }:

mkWeechatPluginFromMainGithub {
  lang = "python";
  baseName = "urlserver";
  inputs = [ pkgs.python ];
}