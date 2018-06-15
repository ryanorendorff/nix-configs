{ pkgs, mkWeechatPluginFromMainGithub, ... }:

mkWeechatPluginFromMainGithub {
  lang = "python";
  baseName = "autosort";
  inputs = [ pkgs.python ];
}