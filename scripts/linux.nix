{ pkgs, config, ... }:

let
  startupBrowser = config.home.file."bin/chrome".target;
  rtvBrowser = config.home.file."bin/chrome-personal".target;
  termiteBrowser = "${pkgs.google-chrome}/bin/google-chrome-stable";
  chromePath = "${pkgs.google-chrome}/bin/google-chrome-stable --profile-directory=\"Default\"";
  chromePersonalPath = "${pkgs.google-chrome}/bin/google-chrome-stable --profile-directory=\"Profile 1\"";
in {
  "bin/tmutt" = {
    text = "${pkgs.termite}/bin/termite -e ${pkgs.neomutt}/bin/neomutt -t mutt";
    executable = true;
  };
  "bin/chrome" = {
    text = "${chromePath}";
    executable = true;
  };
  "bin/chrome-personal" = {
    text = "${chromePersonalPath}";
    executable = true;
  };
  "bin/sync_projects" = {
    text = "${config.home.homeDirectory}/bin/zg_backup && rsync -qa --no-links --no-perms --no-owner --no-group --delete ${config.home.homeDirectory}/projects/backup /mnt/vmware/googledrive/projects/";
    executable = true;
  };
  "bin/thaxor" = {
    text = "${pkgs.termite}/bin/termite -e \"${pkgs.haxor-news}/bin/haxor-news\" -t haxor";
    executable = true;
  };
  "bin/thtop" = {
    text = "${pkgs.termite}/bin/termite -e \"${pkgs.htop}/bin/htop\" -t htop";
    executable = true;
  };
  "bin/tncmpc" = {
    text = "${pkgs.termite}/bin/termite -e \"${pkgs.ncmpc}/bin/ncmpc -h ${config.home.sessionVariables.MPD_HOST}\" -t ncmpc";
    executable = true;
  };
  "bin/trtv" = {
    text = "${pkgs.termite}/bin/termite -e \"env BROWSER=${rtvBrowser} EDITOR=${pkgs.vim}/bin/vim ${pkgs.rtv}/bin/rtv --enable-media\" -t rtv";
    executable = true;
  };
  "bin/tweechat" = {
    text = "${pkgs.termite}/bin/termite -e ${pkgs.weechat}/bin/weechat -t weechat";
    executable = true;
  };
  "bin/todoist" = {
    text = "${chromePath} --app=https://chrome.todoist.com/app?mini=2";
    executable = true;
  };
  "bin/youtube" = {
    text = "${chromePersonalPath} --app=https://www.youtube.com/embed/$1";
    executable = true;
  };
}