{pkgs, config, lib ? pkgs.lib, ...}:

let
  verifyRepos = true;
  sessionVariables = (pkgs.recurseIntoAttrs (import ../sessionVariables {}));
  skipStringIfNot = condition: theString: (lib.optionalString (!condition) "Skip") + theString;
  optionalDagEntryAfter = condition: prereqs: scriptString: if !condition then (config.lib.dag.entryAnywhere "") else ( config.lib.dag.entryAfter prereqs scriptString);
  mutableDotfiles = sessionVariables.PROJECTS + "/nocoolnametom/nix-configs/mutableDotfiles"; 
in {
  tomDoggettInit = config.lib.dag.entryAnywhere ''
    cp -fL ${pkgs.appConfigs.weechat.icon} ${mutableDotfiles}/weechat/.weechat/icon.png
    cp -fL ${pkgs.mine.weechatPlugins.autosort}/autosort.py ${mutableDotfiles}/weechat-plugins/.weechat/python/autosort.py
    cp -fL ${pkgs.mine.weechatPlugins.buffer_autoset}/buffer_autoset.py ${mutableDotfiles}/weechat-plugins/.weechat/python/buffer_autoset.py
    cp -fL ${pkgs.mine.weechatPlugins.text_item}/text_item.py ${mutableDotfiles}/weechat-plugins/.weechat/python/text_item.py
    cp -fL ${pkgs.mine.weechatPlugins.urlserver}/urlserver.py ${mutableDotfiles}/weechat-plugins/.weechat/python/urlserver.py
    cp -fL ${pkgs.mine.weechatPlugins.wee-slack}/wee_slack.py ${mutableDotfiles}/weechat-plugins/.weechat/python/wee_slack.py
    cp -fL ${pkgs.mine.weechatPlugins.highmon}/highmon.pl ${mutableDotfiles}/weechat-plugins/.weechat/perl/highmon.pl
    cp -fL ${pkgs.mine.weechatPlugins.perlexec}/perlexec.pl ${mutableDotfiles}/weechat-plugins/.weechat/perl/perlexec.pl
    stow -d "${mutableDotfiles}" -t ${config.home.homeDirectory} bin weechat weechat-plugins
  '';

  "${skipStringIfNot verifyRepos "tomDoggettInitVerifyRepos"}" = optionalDagEntryAfter verifyRepos ["tomDoggettInit"]''
    ${pkgs.mine.scripts.zg_startup}
    ${pkgs.mine.scripts.personal_startup}
  '';

  "${skipStringIfNot pkgs.stdenv.isDarwin "tomDoggettInitDarwin"}" = optionalDagEntryAfter pkgs.stdenv.isDarwin ["tomDoggettInit"] ''
    cp -fL ${pkgs.mine.weechatPlugins.notification_center}/notification_center.py ${mutableDotfiles}/weechat-plugins/.weechat/python/notification_center.py
    stow -d "${mutableDotfiles}" -t ${config.home.homeDirectory} vscode_macos
  '';

  "${skipStringIfNot pkgs.stdenv.isLinux "tomDoggettInitLinux"}" = optionalDagEntryAfter pkgs.stdenv.isLinux ["tomDoggettInit"] ''
    cp -fL ${pkgs.mine.weechatPlugins.notify_send}/notify_send.py ${mutableDotfiles}/weechat-plugins/.weechat/python/notify_send.py
    stow -d "${mutableDotfiles}" -t ${config.home.homeDirectory} vscode
  '';
}