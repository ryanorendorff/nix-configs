{ pkgs, config, ... }:

let
  files = pkgs.callPackage ../files { config = config; };
  mine = pkgs.callPackage ../systemPackages/mine { };
  chromePath = "${pkgs.google-chrome}/bin/google-chrome-stable --profile-directory=\"Default\"";
  chromePersonalPath = "${pkgs.google-chrome}/bin/google-chrome-stable --profile-directory=\"Profile 1\"";
in {
  ".mailcap" = {
    text = files.mailcap;
    executable = false;
  };
  "bin/tmutt" = {
    text = pkgs.callPackage ./tmutt {};
    executable = true;
  };
  "bin/chrome" = {
    text = pkgs.callPackage ./chrome { chromePath = chromePath; };
    executable = true;
  };
  "bin/chrome-personal" = {
    text = pkgs.callPackage ./chrome-personal { chromePersonalPath = chromePersonalPath; };
    executable = true;
  };
  "bin/thaxor" = {
    text = pkgs.callPackage ./thaxor {};
    executable = true;
  };
  "bin/thtop" = {
    text = pkgs.callPackage ./thtop {};
    executable = true;
  };
  "bin/tncmpc" = {
    text = pkgs.callPackage ./tncmpc {};
    executable = true;
  };
  "bin/trtv" = {
    text = pkgs.callPackage ./trtv { config = config; };
    executable = true;
  };
  "bin/tweechat" = {
    text = pkgs.callPackage ./tweechat { mine = mine; };
    executable = true;
  };
  "bin/todoist" = {
    text = pkgs.callPackage ./todoist { chromePersonalPath = chromePersonalPath; };
    executable = true;
  };
  "bin/youtube" = {
    text = pkgs.callPackage ./youtube { chromePersonalPath = chromePersonalPath; };
    executable = true;
  };
  ".config/i3blocks/config" = {
    text = files.i3blocks;
    executable = false;
  };
  "bin/i3blocks/calendar" = {
    text = pkgs.callPackage ./calendar { };
    executable = true;
  };
  "bin/i3blocks/pomodoro" = {
    text = pkgs.callPackage ./pomodoro { mine = mine; };
    executable = true;
  };
  "bin/i3blocks/bitcoin" = {
    text = pkgs.callPackage ./bitcoin { };
    executable = true;
  };
  "bin/i3blocks/ethereum" = {
    text = pkgs.callPackage ./ethereum { };
    executable = true;
  };
  "bin/i3blocks/googlemusicdesktopplayer" = {
    text = pkgs.callPackage ./googlemusicdesktopplayer { };
    executable = true;
  };
}