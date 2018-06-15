{ pkgs, mkWeechatPluginFromMainGithub, ... }:

mkWeechatPluginFromMainGithub {
  lang = "python";
  baseName = "text_item";
  inputs = [ pkgs.python ];
}