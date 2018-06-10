{ pkgs, ... }:

pkgs.weechat.override {
  extraBuildInputs = [
    pkgs.mine.wee-slack
    pkgs.perl
    pkgs.aspellDicts.en
  ];
  configure = {availablePlugins,...}: {
    plugins =
      with availablePlugins; [
        perl
        (pkgs.mine.weechatPythonPackageList python)
      ];
  };
}