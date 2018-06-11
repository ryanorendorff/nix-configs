{ pkgs, config, ... }:

let
  files = pkgs.callPackage ../files { inherit config; };
  chromePath = "${pkgs.google-chrome}/bin/google-chrome-stable --profile-directory=\"Default\"";
  chromePersonalPath = "${pkgs.google-chrome}/bin/google-chrome-stable --profile-directory=\"Profile 1\"";
in {
  ".mailcap" = {
    text = files.mailcap;
    executable = false;
  };
  "bin/tmutt" = {
    source = pkgs.mine.scripts.tmutt;
    executable = true;
  };
  "bin/chrome" = {
    source = pkgs.mine.scripts.chrome;
    executable = true;
  };
  "bin/chrome-personal" = {
    source = pkgs.mine.scripts.chrome-personal;
    executable = true;
  };
  "bin/thaxor" = {
    source = pkgs.mine.scripts.thaxor;
    executable = true;
  };
  "bin/thtop" = {
    source = pkgs.mine.scripts.thtop;
    executable = true;
  };
  "bin/tncmpc" = {
    source = pkgs.mine.scripts.tncmpc;
    executable = true;
  };
  "bin/trtv" = {
    source = pkgs.mine.scripts.trtv;
    executable = true;
  };
  "bin/tweechat" = {
    source = pkgs.mine.scripts.tweechat;
    executable = true;
  };
  "bin/todoist" = {
    source = pkgs.mine.scripts.todoist;
    executable = true;
  };
  "bin/youtube" = {
    source = pkgs.mine.scripts.youtube;
    executable = true;
  };
  ".config/i3blocks/config" = {
    text = pkgs.appConfigs.i3blocks;
    executable = false;
  };
}