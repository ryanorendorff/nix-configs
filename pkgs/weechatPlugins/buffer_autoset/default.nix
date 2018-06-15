{ pkgs, mkWeechatPluginFromMainGithub, ... }:

mkWeechatPluginFromMainGithub {
  lang = "python";
  baseName = "buffer_autoset";
  inputs = [ pkgs.python ];
}