{
  pkgs,
  lib ? pkgs.lib,
  config,
  anywhere ? (pkgs.callPackage ../../dagEntry.nix {}).anywhere,
  mutableDotfiles ? (toString ../../../mutableDotfiles),
  homeDirectory ? if (lib.hasAttrByPath ["home" "homeDirectory"] config) then config.home.homeDirectory else "~",
  ...
}:

anywhere ''
  mkdir -p ${mutableDotfiles}/weechat/.weechat
  mkdir -p ${mutableDotfiles}/weechat-plugins/.weechat/{python,perl}
  cp -fL ${pkgs.appConfigs.weechat.icon} ${mutableDotfiles}/weechat/.weechat/icon.png
  cp -fL ${pkgs.mine.weechatPlugins.autosort}/autosort.py ${mutableDotfiles}/weechat-plugins/.weechat/python/autosort.py
  cp -fL ${pkgs.mine.weechatPlugins.buffer_autoset}/buffer_autoset.py ${mutableDotfiles}/weechat-plugins/.weechat/python/buffer_autoset.py
  cp -fL ${pkgs.mine.weechatPlugins.text_item}/text_item.py ${mutableDotfiles}/weechat-plugins/.weechat/python/text_item.py
  cp -fL ${pkgs.mine.weechatPlugins.urlserver}/urlserver.py ${mutableDotfiles}/weechat-plugins/.weechat/python/urlserver.py
  cp -fL ${pkgs.mine.weechatPlugins.wee-slack}/wee_slack.py ${mutableDotfiles}/weechat-plugins/.weechat/python/wee_slack.py
  cp -fL ${pkgs.mine.weechatPlugins.highmon}/highmon.pl ${mutableDotfiles}/weechat-plugins/.weechat/perl/highmon.pl
  cp -fL ${pkgs.mine.weechatPlugins.perlexec}/perlexec.pl ${mutableDotfiles}/weechat-plugins/.weechat/perl/perlexec.pl
  ${pkgs.stow}/bin/stow -d "${mutableDotfiles}" -t ${homeDirectory} bin weechat weechat-plugins
''
